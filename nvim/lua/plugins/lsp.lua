return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "smjonas/inc-rename.nvim",  -- Better rename UI
            "ray-x/lsp_signature.nvim",  -- Better signature help
            "folke/trouble.nvim",        -- Better diagnostics list
        },
        config = function()
            -- Setup better rename UI
            require("inc_rename").setup({
                input_buffer_type = "dressing",
            })

            -- Setup LSP signature
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded",
                },
                floating_window = false,  -- Use virtual text
                hint_prefix = "󰏚 ",
            })

            -- Setup neovim lua configuration
            require("neodev").setup({
                library = {
                    plugins = { "nvim-dap-ui" }, -- Add DAP support
                    types = true,
                },
            })

            -- Setup fidget with better styling
            require("fidget").setup({
                progress = {
                    suppress_on_insert = false,
                    ignore_done_already = false,
                    ignore_empty_message = false,
                    display = {
                        render_limit = 16,
                        done_ttl = 3,
                        progress_ttl = math.huge,
                    },
                },
                notification = {
                    window = {
                        winblend = 0,
                        border = "rounded",
                        relative = "editor",
                    },
                },
            })

            -- Enable inlay hints by default
            local function enable_inlay_hints(client, bufnr)
                if client.supports_method('textDocument/inlayHint') then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            end
            -- LSP on_attach function
            local on_attach = function(client, bufnr)
                enable_inlay_hints(client, bufnr)
                
                -- Enhanced hover capabilities
                if client.server_capabilities.hoverProvider then
                    vim.o.updatetime = 250
                    vim.api.nvim_create_autocmd("CursorHold", {
                        buffer = bufnr,
                        callback = function()
                            local opts = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                border = 'rounded',
                                source = 'always',
                                prefix = ' ',
                                scope = 'cursor',
                            }
                            vim.diagnostic.open_float(opts)
                        end
                    })
                end
            end
            -- Enhanced LSP mappings with better descriptions
            local function map(mode, lhs, rhs, opts)
                local options = { noremap = true, silent = true }
                if opts then options = vim.tbl_extend("force", options, opts) end
                vim.keymap.set(mode, lhs, rhs, options)
            end

            -- Navigation
            map('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Go to Definition' })
            map('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: Go to Declaration' })
            map('n', 'gi', vim.lsp.buf.implementation, { desc = 'LSP: Go to Implementation' })
            map('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: Find References' })
            map('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'LSP: Type Definition' })

            -- Documentation
            map('n', 'K', function()
                -- Attempt to show signature help first
                local sig_ok, _ = pcall(vim.lsp.buf.signature_help)
                if not sig_ok then
                    -- Fallback to hover if signature help isn't available
                    vim.lsp.buf.hover()
                end
            end, { desc = 'LSP: Show type information and documentation' })
            map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Help' })

            -- Workspace
            map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP: Add Workspace Folder' })
            map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP: Remove Workspace Folder' })
            map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = 'LSP: List Workspace Folders' })

            -- Code Actions
            map('n', '<leader>rn', function() return ':IncRename ' .. vim.fn.expand('<cword>') end, { desc = 'LSP: Rename Symbol', expr = true })
            map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: Code Actions' })
            map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, { desc = 'LSP: Format Document' })

            -- Symbols
            map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = 'LSP: Document Symbols' })
            map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'LSP: Workspace Symbols' })

            -- Diagnostics navigation
            map('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP: Previous Diagnostic' })
            map('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP: Next Diagnostic' })
            map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'LSP: Float Diagnostic' })
            map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'LSP: Set Diagnostic to Location List' })
            map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = 'LSP: Toggle Diagnostics Window' })

            -- Enhanced LSP handlers
            local float_config = {
                border = "rounded",
                max_width = 80,
                max_height = 40,
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                function(_, result, ctx, config)
                    config = config or {}
                    config.focus_id = ctx.method
                    if not (result and result.contents) then
                        return
                    end
                    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                    markdown_lines = vim.list_extend(
                        { "```" .. vim.bo.filetype, vim.fn.expand("<cword>") .. ": " },
                        markdown_lines
                    )
                    table.insert(markdown_lines, "```")
                    return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
                end,
                {
                    border = "rounded",
                    max_width = 80,
                    max_height = 40,
                    focusable = true,
                    focus = false,
                    close_events = { "CursorMoved", "BufHidden", "InsertCharPre" }
                }
            )
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

            -- Enhanced diagnostic configuration
            vim.diagnostic.config({
                virtual_text = {
                    prefix = '●',
                    source = 'always',
                    spacing = 4,
                },
                float = float_config,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Diagnostic signs with better icons
            local signs = {
                Error = " ",
                Warn = " ",
                Hint = "󰌵 ",
                Info = " ",
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",         -- Better completion icons
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            -- Load VSCode-like snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            
            -- Add custom snippets
            luasnip.config.setup({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            cmp.setup({
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                    autocomplete = false,  -- Disable automatic completion
                    keyword_length = 1,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'luasnip', priority = 750 },
                    { name = 'nvim_lua', priority = 500 },
                    { name = 'path', priority = 250 },
                    { name = 'buffer', priority = 100 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '...',
                        before = function(entry, vim_item)
                            vim_item.menu = ({
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snippet]",
                                buffer = "[Buffer]",
                                path = "[Path]",
                                nvim_lua = "[Lua]",
                            })[entry.source.name]
                            return vim_item
                        end,
                    }),
                },
                window = {
                    completion = cmp.config.window.bordered({
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    }),
                    documentation = cmp.config.window.bordered({
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    }),
                },
                experimental = {
                    ghost_text = true,
                },
            })

            -- Set up enhanced command-line completion
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'path', priority = 500 },
                    { name = 'cmdline', priority = 300 }
                }
            })

            -- Set up enhanced search completion
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer', priority = 500 }
                }
            })
        end
    },
}