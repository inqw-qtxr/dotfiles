return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "folke/neodev.nvim", -- Adds support for Neovim Lua API
            "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim", -- Standalone UI for LSP progress
        },
        config = function()
            -- Setup neovim lua configuration
            require("neodev").setup()

            -- Setup fidget to show LSP progress
            require("fidget").setup({
                progress = {
                    suppress_on_insert = false,
                    ignore_done_already = false,
                    ignore_empty_message = false,
                },
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            })

            -- Global LSP mappings
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to Declaration' })
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to Implementation' })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find References' })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename Symbol' })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Actions' })
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type Definition' })
            vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = 'Document Symbols' })
            vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'Workspace Symbols' })

            -- Diagnostic keymaps
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Float Diagnostic' })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Set Diagnostic to Location List' })

            -- LSP handlers configuration
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    border = "rounded",
                    width = 60,
                }
            )

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help, {
                    border = "rounded",
                    width = 60,
                }
            )

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                },
            })

            -- Set up signs
            local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- LSP settings (show documentation in a fancy floating window)
            local float_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
            }

            vim.diagnostic.config({ float = float_opts })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
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
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'nvim_lua' },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- Kind icons
                        local kind_icons = {
                            Text = "",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰇽",
                            Variable = "󰂡",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "󰅲",
                        }
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        return vim_item
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })

            -- Set up command-line completion
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'cmdline' }
                })
            })

            -- Set up search completion
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
        end
    },
}