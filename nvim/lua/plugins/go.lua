return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "gopls",            -- Go LSP
                "golines",          -- Go formatter for line length
                "gofumpt",          -- Stricter Go formatter
                "goimports",        -- Go import management
                "gomodifytags",     -- Go modify struct tags
                "impl",             -- Go interface implementation
                "gotests",          -- Go test generation
                "delve",            -- Go debugger
                "golangci-lint",    -- Go linter
                "revive",           -- Go linter (additional)
            },
        },
        config = function()
            local function on_attach(client, bufnr)
                vim.keymap.set("n", "<leader>gsj", "<cmd>GoAddTag json<CR>", { desc = "Go: Add json tags" })
                vim.keymap.set("n", "<leader>gsy", "<cmd>GoAddTag yaml<CR>", { desc = "Go: Add yaml tags" })
                vim.keymap.set("n", "<leader>gr", "<cmd>GoRemoveTags<CR>", { desc = "Go: Remove all tags" })
                vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Go: Run tests" })
                vim.keymap.set("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", { desc = "Go: Test function" })
                vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFile<CR>", { desc = "Go: Test file" })
                vim.keymap.set("n", "<leader>gc", "<cmd>GoCmt<CR>", { desc = "Go: Generate comment" })
                vim.keymap.set("n", "<leader>gfi", "<cmd>GoFillStruct<CR>", { desc = "Go: Fill struct" })
                vim.keymap.set("n", "<leader>gim", "<cmd>GoImpl<CR>", { desc = "Go: Generate interface implementation" })
                vim.keymap.set("n", "<leader>gif", "<cmd>GoIfErr<CR>", { desc = "Go: Generate if err" })
                vim.keymap.set("n", "<leader>gat", "<cmd>GoAddTest<CR>", { desc = "Go: Generate test for function" })
                vim.keymap.set("n", "<leader>gal", "<cmd>GoCodeLenAct<CR>", { desc = "Go: Code lens" })
                vim.keymap.set("n", "<leader>glt", "<cmd>GoLint<CR>", { desc = "Go: Lint" })
            end
            require("go").setup({
                lsp_cfg = true,
                lsp_on_attach = on_attach,
                lsp_codelens = true,
                lsp_inlay_hints = {
                    enable = true,
                    parameter_hints_prefix = "󰊕 ", -- Show parameter names
                    other_hints_prefix = "=> ",   -- Show type hints
                },
                gofmt = 'golines', -- Use golines for formatting
                max_line_len = 120,
                goimport = 'goimports', -- Use goimports
                fillstruct = 'gopls',
                test_runner = 'go',
                test_open_cmd = 'edit',
                dap_debug = true,
                dap_debug_gui = true,
                dap_debug_keymap = true,
                dap_port = 38697,
                icons = {
                    breakpoint = '🔍',
                    currentpos = '🏃',
                },
                floaterm = { position = 'center', width = 0.8, height = 0.8 },
                trouble = true,
            })
            -- Configure gopls
            require("lspconfig").gopls.setup({
                settings = {
                    gopls = {
                        analyses = {
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        experimentalPostfixCompletions = true,
                        gofumpt = true,
                        staticcheck = true,
                        usePlaceholders = true,
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
                    },
                },
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod", "gowork", "gotmpl" },
        build = function()
            vim.cmd("silent UpdateRemotePlugins")
        end
    },
    {
        "olexsmir/gopher.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("gopher").setup({
                commands = {
                    go = "go",
                    gomodifytags = "gomodifytags",
                    gotests = "gotests",
                    impl = "impl",
                    iferr = "iferr",
                    comment = "comment",
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            table.insert(opts.formatters_by_ft, {
                go = { "gofmt", "goimports" },
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                go = { "golangcilint" }
            }
        end,
    },
    {
        "leoluz/nvim-dap-go",
        config = function()
            require("dap-go").setup()
        end,
    },
}