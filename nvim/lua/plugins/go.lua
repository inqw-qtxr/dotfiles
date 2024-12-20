return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                -- Go toolchain settings
                go = "go",                -- Path to go executable
                gofmt = "golines",        -- Use golines for max_line_len support
                max_line_len = 120,       -- Now effective since we're using golines
                tag_transform = false,    -- tag_transfer check gomodifytags for details
                test_template = "",       -- default to testify if not set; g:go_nvim_tests_template check gotests for details
                test_template_dir = "",   -- default to nil if not set; g:go_nvim_tests_template_dir check gotests for details
                comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. 󰟓

                -- Plugin settings
                icons = { breakpoint = "🔴", currentpos = "🔸" },
                notify_options = {
                    silent = true,
                    clear_previous = true,
                },
                verbose = false,
                lsp_cfg = {
                    capabilities = capabilities,
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                                unusedwrite = true,
                                useany = true,
                                nilness = true,
                                ST1000 = true, -- check for missing package documentation
                                ST1003 = true, -- check for proper naming
                            },
                            staticcheck = true,
                            gofumpt = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                            semanticTokens = true,
                            codelenses = {
                                gc_details = true,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
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
                        },
                    },
                },
                lsp_gofumpt = true,   -- true: set default gofmt in gopls format to gofumpt
                lsp_on_attach = true, -- use on_attach from go.nvim
                lsp_document_formatting = true,
                -- lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
                lsp_codelens = true,
                diagnostic = {
                    hdlr = true, -- hook lsp diag handler
                    underline = true,
                    virtual_text = { space = 0, prefix = "" },
                    signs = true,
                },

                -- Highlighting and syntax
                gopls_cmd = nil,
                gopls_remote_auto = false, -- Disabling custom gopls settings here
                test_runner = "go",
                dap_debug = false,
                sign_priority = 9,
            })



            -- Set up autocommands for Go files
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimport()
                end,
                group = format_sync_grp,
            })

            -- Go-specific keymaps
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
            end

            -- Code actions
            map("n", "<leader>gfs", "<cmd>GoFillStruct<CR>", "Fill struct")
            map("n", "<leader>gfp", "<cmd>GoFixPlurals<CR>", "Fix plurals")
            map("n", "<leader>gat", "<cmd>GoAddTag<CR>", "Add tags to struct")
            map("n", "<leader>grt", "<cmd>GoRmTag<CR>", "Remove tags from struct")
            map("n", "<leader>gct", "<cmd>GoClearTag<CR>", "Clear tags from struct")
            map("n", "<leader>gim", "<cmd>GoImpl<CR>", "Generate interface implementation")

            -- Testing
            map("n", "<leader>gte", "<cmd>GoTest<CR>", "Run tests")
            map("n", "<leader>gtf", "<cmd>GoTestFunc<CR>", "Test function")
            map("n", "<leader>gtc", "<cmd>GoTestCoverage<CR>", "Test coverage")

            -- Alternate between test and implementation
            map("n", "<leader>ga", "<cmd>GoAlt<CR>", "Go to alternate file")
            map("n", "<leader>gat", "<cmd>GoAltV<CR>", "Go to alternate file in vsplit")

            -- Code info and navigation
            map("n", "<leader>gd", "<cmd>GoDef<CR>", "Go to definition")
            map("n", "<leader>gdc", "<cmd>GoDefCallback<CR>", "Go to definition callback")
            map("n", "<leader>gr", "<cmd>GoRename<CR>", "Rename symbol")
            map("n", "<leader>gi", "<cmd>GoInfo<CR>", "Show symbol info")

            -- Debug
            map("n", "<leader>gdb", "<cmd>GoDebug<CR>", "Start debugging")
            map("n", "<leader>gdt", "<cmd>GoDebugTest<CR>", "Debug test")
            map("n", "<leader>gdB", "<cmd>GoBreakpoint<CR>", "Toggle breakpoint")
        end
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("dap-go").setup({
                dap_configurations = {
                    {
                        type = "go",
                        name = "Debug Package",
                        request = "launch",
                        program = "${fileDirname}",
                    },
                    {
                        type = "go",
                        name = "Debug Test",
                        request = "launch",
                        mode = "test",
                        program = "${fileDirname}",
                    },
                },
                delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                    port = "${port}",
                },
            })
        end,
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
                },
            })
        end,
    }
}
