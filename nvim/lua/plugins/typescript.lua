return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup({
                settings = {
                    -- Enable inlay hints
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                    -- Specify additional code actions
                    tsserver_format_options = {
                        allowIncompleteCompletions = false,
                        allowRenameOfImportPath = false,
                    },
                },
                handlers = {
                    -- Handle specific TypeScript actions
                    ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
                        if result.diagnostics == nil then return end
                        -- Process TypeScript specific diagnostics
                        local processed = {}
                        for _, diagnostic in ipairs(result.diagnostics) do
                            -- Enhance TypeScript diagnostic messages
                            diagnostic.message = "[TS] " .. diagnostic.message
                            table.insert(processed, diagnostic)
                        end
                        result.diagnostics = processed
                        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
                    end,
                },
            })

            -- TypeScript specific keymaps
            local bufnr = vim.api.nvim_get_current_buf()
            vim.keymap.set("n", "<leader>tsi", ":TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
            vim.keymap.set("n", "<leader>tsa", ":TSToolsAddMissingImports<CR>", { desc = "Add Missing Imports" })
            vim.keymap.set("n", "<leader>tsf", ":TSToolsFixAll<CR>", { desc = "Fix All" })
            vim.keymap.set("n", "<leader>tsr", ":TSToolsRenameFile<CR>", { desc = "Rename File" })
            vim.keymap.set("n", "<leader>tsd", ":TSToolsGoToSourceDefinition<CR>", { desc = "Go To Source Definition" })
        end,
    },
    {
        "maxmellon/vim-jsx-pretty",
        dependencies = { "yuezk/vim-js" },
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup({
                filetypes = {
                    "html",
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "tsx",
                    "jsx",
                    "xml",
                },
            })
        end,
    },
    {
        "MunifTanjim/prettier.nvim",
        config = function()
            require("prettier").setup({
                bin = 'prettier',
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "scss",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                },
            })
        end,
    },
}