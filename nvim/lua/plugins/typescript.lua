-- Helper functions
local function create_typescript_keymaps(maps)
    for key, cmd in pairs(maps) do
        vim.keymap.set("n", "<leader>ts" .. key, cmd[1], { desc = cmd[2], buffer = true })
    end
end

local function create_formatting_keymaps()
    vim.keymap.set("n", "<leader>fp", function()
        vim.cmd("Prettier")
        vim.notify("Formatted with Prettier", vim.log.levels.INFO)
    end, { desc = "Format with Prettier" })
end

return {
    -- TypeScript Tools configuration
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { 
            "nvim-lua/plenary.nvim", 
            "neovim/nvim-lspconfig",
            "folke/trouble.nvim",
        },
        config = function()
            local ts_tools = require("typescript-tools")

            -- TypeScript server preferences
            local server_settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                tsserver_format_options = {
                    allowIncompleteCompletions = false,
                    allowRenameOfImportPath = false,
                },
                -- Additional settings
                complete_function_calls = true,
                include_completions_with_insert_text = true,
                code_lens = "all",
            }

            -- Enhanced diagnostic handler
            local function enhance_typescript_diagnostics(_, result, ctx, config)
                if not result.diagnostics then return end
                
                result.diagnostics = vim.tbl_map(function(diagnostic)
                    local severity_icons = {
                        [1] = "🔴",
                        [2] = "🟡",
                        [3] = "🔵",
                        [4] = "🟢",
                    }
                    local icon = severity_icons[diagnostic.severity] or ""
                    diagnostic.message = string.format("%s [TS] %s", icon, diagnostic.message)
                    return diagnostic
                end, result.diagnostics)

                vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
            end

            -- Setup TypeScript tools
            ts_tools.setup({
                settings = server_settings,
                handlers = {
                    ["textDocument/publishDiagnostics"] = enhance_typescript_diagnostics,
                },
                flags = {
                    debounce_text_changes = 150,
                },
                capabilities = {
                    documentFormattingProvider = true,
                    documentRangeFormattingProvider = true,
                    codeActionProvider = true,
                },
            })

            -- TypeScript keymaps
            local typescript_keymaps = {
                i = { ":TSToolsOrganizeImports<CR>", "Organize Imports" },
                a = { ":TSToolsAddMissingImports<CR>", "Add Missing Imports" },
                f = { ":TSToolsFixAll<CR>", "Fix All" },
                r = { ":TSToolsRenameFile<CR>", "Rename File" },
                d = { ":TSToolsGoToSourceDefinition<CR>", "Go To Source Definition" },
                t = { ":TSToolsGoToSourceDefinition split<CR>", "Go To Definition in Split" },
                R = { ":TSToolsRename<CR>", "Rename Symbol" },
                u = { ":TSToolsRemoveUnused<CR>", "Remove Unused" },
                s = { ":TSToolsShowReferences<CR>", "Show References" },
            }

            create_typescript_keymaps(typescript_keymaps)

            -- Autocommands for TypeScript files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "typescript", "typescriptreact" },
                callback = function()
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = 0,
                        callback = function()
                            vim.cmd("TSToolsOrganizeImports")
                        end,
                    })
                end,
            })
        end,
    },

    -- JSX/TSX syntax highlighting
    {
        "maxmellon/vim-jsx-pretty",
        dependencies = { 
            "yuezk/vim-js",
            "HerringtonDarkholme/yats.vim",
        },
        config = function()
            vim.g.vim_jsx_pretty_colorful_config = 1
        end,
    },

    -- Auto-close tags
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup({
                filetypes = {
                    "html", "javascript", "typescript",
                    "javascriptreact", "typescriptreact",
                    "tsx", "jsx", "xml", "markdown",
                    "vue", "svelte", "php", "astro",
                },
                skip_tags = {
                    'area', 'base', 'br', 'col', 'command',
                    'embed', 'hr', 'img', 'slot', 'input',
                    'keygen', 'link', 'meta', 'param',
                    'source', 'track', 'wbr'
                },
            })
        end,
    },

    -- Prettier configuration
    {
        "MunifTanjim/prettier.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "jose-elias-alvarez/null-ls.nvim",
        },
        config = function()
            local prettier = require("prettier")

            -- Supported filetypes
            local filetypes = {
                "css", "graphql", "html", "javascript",
                "javascriptreact", "json", "less",
                "markdown", "scss", "typescript",
                "typescriptreact", "yaml", "vue",
                "svelte", "php", "astro", "prisma",
            }

            -- Prettier CLI options
            local cli_options = {
                arrow_parens = "always",
                bracket_spacing = true,
                bracket_same_line = false,
                embedded_language_formatting = "auto",
                end_of_line = "lf",
                html_whitespace_sensitivity = "css",
                jsx_single_quote = false,
                print_width = 80,
                prose_wrap = "preserve",
                quote_props = "as-needed",
                semi = true,
                single_quote = false,
                tab_width = 2,
                trailing_comma = "es5",
                use_tabs = false,
                vue_indent_script_and_style = false,
                parser = "typescript",
            }

            -- Prettier setup
            prettier.setup({
                bin = 'prettier',
                filetypes = filetypes,
                ["null-ls"] = {
                    condition = function()
                        return prettier.config_exists({
                            check_package_json = true,
                            check_patterns = {
                                ".prettierrc",
                                ".prettierrc.json",
                                ".prettierrc.yml",
                                ".prettierrc.yaml",
                                ".prettierrc.json5",
                                ".prettierrc.js",
                                "prettier.config.js",
                            },
                        })
                    end,
                    runtime_condition = function(params)
                        -- Don't format if file is too large (> 100KB)
                        return vim.fn.getfsize(params.bufname) <= 100000
                    end,
                    timeout = 5000,
                },
                cli_options = cli_options,
            })

            -- Set up format on save
            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    create_formatting_keymaps()
                end,
            })
        end,
    },
}