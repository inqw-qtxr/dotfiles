return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = {
            "LspInfo",
            "LspInstall",
            "LspUninstall",
        },
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                        border = "rounded",
                    },
                    max_concurrent_installers = 10,
                    pip = {
                        upgrade_pip = true,
                    },
                    log_level = vim.log.levels.INFO,
                },
                build = ":MasonUpdate",
            },
            {
                "williamboman/mason-lspconfig.nvim",
                opts = {
                    ensure_installed = {
                        "lua_ls",
                        "pyright",
                        "gopls",
                        "ts_ls",
                        "ruby_lsp",
                    },
                    automatic_installation = false,
                },
            },
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "j-hui/fidget.nvim",
            "smjonas/inc-rename.nvim",
            "ray-x/lsp_signature.nvim",
            "folke/trouble.nvim",
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
                floating_window = false, -- Use virtual text
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

            local function enable_inlay_hints(client, bufnr)
                if client.supports_method("textDocument/inlayHint") then
                    if vim.lsp.inlay_hint
                        and type(vim.lsp.inlay_hint.enable) == "function"
                    then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    else
                        vim.lsp.buf_request(bufnr, "textDocument/inlayHint", {
                            textDocument = vim.lsp.util.make_text_document_params(bufnr),
                        }, function(err, _, result)
                            if err then
                                return
                            end
                            if vim.lsp.inlay_hints and vim.lsp.inlay_hints.set_hints then
                                vim.lsp.inlay_hints.set_hints(bufnr, result)
                            end
                        end)
                    end
                end
            end

            local on_attach = function(client, bufnr)
                enable_inlay_hints(client, bufnr)
                if client.name == "gopls" then
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end
                    map("n", "<leader>gt", "<cmd>GoTest<CR>", "Run Go Tests")
                    map("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", "Run Test Function")
                    map("n", "<leader>gi", "<cmd>GoImplements<CR>", "Show Implementations")
                    map("n", "<leader>gci", "<cmd>GoCoverage<CR>", "Show Test Coverage")
                    map("n", "<leader>gcl", "<cmd>GoCoverageClear<CR>", "Clear Coverage")
                end
                if client.name == "pyright" then
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end
                    -- Python specific commands
                    vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
                        vim.lsp.buf.execute_command({
                            command = "pyright.organizeimports",
                            arguments = { vim.api.nvim_buf_get_name(0) },
                        })
                    end, { desc = "Organize Imports" })
                    map("n", "<leader>po", "<cmd>OrganizeImports<CR>", "Organize Imports")
                end

                -- Enhanced hover capabilities
                if client.server_capabilities.hoverProvider then
                    vim.o.updatetime = 250
                    vim.api.nvim_create_autocmd("CursorHold", {
                        buffer = bufnr,
                        callback = function()
                            local opts = {
                                focusable = false,
                                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                                border = "rounded",
                                source = "always",
                                prefix = " ",
                                scope = "cursor",
                            }
                            vim.diagnostic.open_float(opts)
                        end,
                    })
                end
            end

            -- Enhanced LSP mappings with better descriptions
            local function map(mode, lhs, rhs, opts)
                local options = { noremap = true, silent = true }
                if opts then
                    options = vim.tbl_extend("force", options, opts)
                end
                vim.keymap.set(mode, lhs, rhs, options)
            end

            -- Navigation
            map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
            map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to Declaration" })
            map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to Implementation" })
            map("n", "gr", vim.lsp.buf.references, { desc = "LSP: Find References" })
            map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP: Type Definition" })

            -- Documentation
            map("n", "K", function()
                -- Attempt to show signature help first
                local sig_ok, _ = pcall(vim.lsp.buf.signature_help)
                if not sig_ok then
                    -- Fallback to hover if signature help isn't available
                    vim.lsp.buf.hover()
                end
            end, { desc = "LSP: Show type information and documentation" })
            map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })

            -- Workspace
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: Add Workspace Folder" })
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: Remove Workspace Folder" })
            map("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, { desc = "LSP: List Workspace Folders" })

            -- Code Actions
            map("n", "<leader>rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { desc = "LSP: Rename Symbol", expr = true })
            map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Actions" })
            map("n", "<leader>cf", function()
                vim.lsp.buf.format({ async = true })
            end, { desc = "LSP: Format Document" })

            -- Symbols
            map(
                "n",
                "<leader>ds",
                require("telescope.builtin").lsp_document_symbols,
                { desc = "LSP: Document Symbols" }
            )
            map(
                "n",
                "<leader>ws",
                require("telescope.builtin").lsp_dynamic_workspace_symbols,
                { desc = "LSP: Workspace Symbols" }
            )

            -- Diagnostics navigation
            map("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Previous Diagnostic" })
            map("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Next Diagnostic" })
            map("n", "<leader>e", vim.diagnostic.open_float, { desc = "LSP: Float Diagnostic" })
            map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "LSP: Set Diagnostic to Location List" })
            map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "LSP: Toggle Diagnostics Window" })

            -- Enhanced LSP handlers
            local float_config = {
                border = "rounded",
                max_width = 80,
                max_height = 40,
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = "always",
                prefix = " ",
                scope = "cursor",
            }

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(function(_, result, ctx, config)
                config = config or {}
                config.focus_id = ctx.method
                if not (result and result.contents) then
                    return
                end
                local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                markdown_lines =
                    vim.list_extend({ "```" .. vim.bo.filetype, vim.fn.expand("<cword>") .. ": " }, markdown_lines)
                table.insert(markdown_lines, "```")
                return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
            end, {
                border = "rounded",
                max_width = 80,
                max_height = 40,
                focusable = true,
                focus = false,
                close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
            })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

            -- Enhanced diagnostic configuration
            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                    source = true,
                    spacing = 4,
                    severity = {
                        min = vim.diagnostic.severity.ERROR,
                    }
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

            -- Enhanced LSP capabilities configuration
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Enhanced capabilities for specific languages
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                },
            }
            capabilities.textDocument.completion.completionItem.preselectSupport = true
            capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
            capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
            capabilities.textDocument.completion.completionItem.deprecatedSupport = true
            capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
            capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
            capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
            capabilities.textDocument.codeAction = {
                dynamicRegistration = true,
                codeActionLiteralSupport = {
                    codeActionKind = {
                        valueSet = (function()
                            local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                            table.sort(res)
                            return res
                        end)(),
                    },
                },
            }

            -- Mason + Mason-LSPConfig setup
            local mason_ok, mason = pcall(require, "mason")
            local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not mason_ok or not mason_lsp_ok then
                return
            end

            mason.setup()

            -- Servers for Go, Ruby, JS/TS, Python, Lua, shell, etc.
            local servers = {
                gopls = {
                    settings = {
                        gopls = {
                            experimentalPostfixCompletions = true,
                            gofumpt = true,
                            staticcheck = true,
                            usePlaceholders = true,
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            semanticTokens = true,
                            codelenses = {
                                gc_details = true,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                        },
                    },
                },
                ruby_lsp = {
                    settings = {
                        -- Enable formatting through ruby-lsp
                        formatting = true,
                        -- Enable RuboCop integration
                        rubocop = {
                            enable = true,
                            -- Use bundler to run RuboCop if Gemfile exists
                            command = function()
                                if vim.fn.filereadable("Gemfile") == 1 then
                                    return "bundle exec rubocop"
                                else
                                    return "rubocop"
                                end
                            end,
                        },
                        -- Enable features provided by ruby-lsp
                        features = {
                            diagnostics = true,          -- Enable default diagnostics
                            documentHighlights = true,   -- Enable document highlights
                            documentSymbols = true,      -- Enable document symbols
                            foldingRanges = true,        -- Enable folding ranges
                            selectionRanges = true,      -- Enable selection ranges
                            semanticHighlighting = true, -- Enable semantic highlighting
                            formatting = true,           -- Enable formatting
                            codeActions = true,          -- Enable code actions
                        },
                        -- Enable hover documentation
                        hover = true,
                        -- Enable completion
                        completion = true,
                        -- Formatter settings
                        formatter = {
                            enableDecorations = true,
                            indentSize = 2,
                            maxLineLength = 100,
                            quotesStyle = "single", -- Can be 'single' or 'double'
                        },
                        -- Lint settings
                        lint = {
                            enabled = true,
                            rules = {}, -- Add specific rules here if needed
                        },
                    },
                    on_attach = function(client, bufnr)
                        -- Add Ruby-specific keymaps here
                        local function map(mode, lhs, rhs, desc)
                            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                        end

                        -- Ruby-specific mappings
                        map("n", "<leader>rt", "<cmd>RubyTest<CR>", "Run Ruby test under cursor")
                        map("n", "<leader>rf", "<cmd>RubyFormat<CR>", "Format Ruby file")
                        map("n", "<leader>rr", "<cmd>RubyReload<CR>", "Reload Ruby environment")

                        -- Call the original on_attach if it exists
                        if on_attach then
                            on_attach(client, bufnr)
                        end
                    end,
                },
                ts_ls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                enabled = true,
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "workspace",
                                typeCheckingMode = "basic",
                                diagnosticSeverityOverrides = {
                                    reportGeneralTypeIssues = "warning",
                                    reportOptionalMemberAccess = "warning",
                                    reportOptionalSubscript = "warning",
                                    reportPrivateImportUsage = "warning",
                                },
                                inlayHints = {
                                    variableTypes = true,
                                    functionReturnTypes = true,
                                    parameterTypes = true,
                                },
                            },
                        },
                    },
                },
                bashls = {},
                eslint = {},
                lua_ls = {
                    -- Example Lua config
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            telemetry = { enable = false },
                        },
                    },
                },
            }

            mason_lspconfig.setup({
                ensure_installed = {
                    -- Lua
                    "lua_ls",

                    -- Python
                    "pyright", -- Type checking and intellisense

                    -- Go
                    "gopls", -- Official Go language server

                    -- TypeScript/JavaScript
                    "ts_ls",  -- TypeScript server
                    "eslint", -- Linting

                    -- Ruby
                    "ruby_lsp",   -- Official Ruby LSP
                    "solargraph", -- Documentation and intellisense

                    -- Shell
                    "bashls", -- Bash language server
                },
                automatic_installation = true,
            })

            -- Pull in completion & on_attach from your existing setup:
            local lspconfig = require("lspconfig")

            -- Finally, set up each server:
            for server_name, server_settings in pairs(servers) do
                lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, server_settings))
            end
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lua",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim", -- Better completion icons
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

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
                    completeopt = "menu,menuone,noinsert",
                    autocomplete = false, -- Disable automatic completion
                    keyword_length = 1,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                    { name = "nvim_lua", priority = 500 },
                    { name = "path",     priority = 250 },
                    { name = "buffer",   priority = 100 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
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
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "path",    priority = 500 },
                    { name = "cmdline", priority = 300 },
                },
            })

            -- Set up enhanced search completion
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer", priority = 500 },
                },
            })
        end,
    },
}
