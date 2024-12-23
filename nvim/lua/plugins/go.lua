return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- LSP
                "gopls",            -- Go LSP
                -- Formatters
                "golines",          -- Line length formatter
                "gofumpt",          -- Strict formatter
                "goimports",        -- Import management
                -- Debug
                "delve",            -- Debugger
                -- Linters
                "golangci-lint",    -- Primary linter
                "revive",           -- Additional linter
                -- Tools
                "gomodifytags",     -- Modify struct tags
                "impl",             -- Interface implementation
                "gotests",          -- Test generation
                "iferr",            -- Error handling
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
        },
    },
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- Shared options
            go = "go",
            goimports = "goimports",        -- Updated to use goimports
            fillstruct = "gopls",
            formatter = "gofumpt",          -- Changed to gofumpt as base formatter
            tag_transform = false,
            test_template = "",
            test_dir = "",
            comment_placeholder = "",
            verbose = false,
            
            -- Lsp configurations
            lsp_cfg = {
                settings = {
                    gopls = {
                        -- Analysis settings
                        analyses = {
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                            shadow = true,
                        },
                        -- Experimental features
                        experimentalPostfixCompletions = true,
                        gofumpt = true,
                        staticcheck = true,
                        usePlaceholders = true,
                        -- Code lenses
                        codelenses = {
                            gc_details = true,
                            generate = true,
                            regenerate_cgo = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        -- Completion settings
                        completionDocumentation = true,
                        deepCompletion = true,
                        matcher = "Fuzzy",
                        -- Hints
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
            
            -- Diagnostic settings
            lsp_diag_update_in_insert = false,
            lsp_document_formatting = true,
            -- Inlay hints
            lsp_inlay_hints = {
                enable = true,
                parameter_hints_prefix = "󰊕 ",
                other_hints_prefix = "=> ",
                highlight = "Comment",
            },
            
            -- Test configurations
            test_runner = 'go',
            run_in_floaterm = true,
            test_open_cmd = 'edit',
            
            -- Debugging configurations
            dap_debug = true,
            dap_debug_gui = true,
            dap_debug_keymap = true,
            dap_debug_vt = true,
            dap_port = 38697,
            debugger_cmd = "dlv",
            debugger_args = {"dap", "-l", "127.0.0.1:${port}"},
            
            -- Icons for virtual text
            icons = {
                breakpoint = "🔴",
                currentpos = "🔷",
            },
        },
        keys = {
            -- Code manipulation
            { "<leader>gsj", "<cmd>GoAddTag json<CR>", desc = "Add json tags" },
            { "<leader>gsy", "<cmd>GoAddTag yaml<CR>", desc = "Add yaml tags" },
            { "<leader>gfi", "<cmd>GoFillStruct<CR>", desc = "Fill struct" },
            { "<leader>gie", "<cmd>GoIfErr<CR>", desc = "Add if err" },
            { "<leader>gim", "<cmd>GoImpl<CR>", desc = "Implement interface" },
            { "<leader>gc", "<cmd>GoCmt<CR>", desc = "Generate comment" },
            
            -- Testing
            { "<leader>gt", "<cmd>GoTest<CR>", desc = "Run tests" },
            { "<leader>gtf", "<cmd>GoTestFunc<CR>", desc = "Test function" },
            { "<leader>gT", "<cmd>GoTestFile<CR>", desc = "Test file" },
            { "<leader>gat", "<cmd>GoAddTest<CR>", desc = "Generate test for function" },
            
            -- Running and building
            { "<leader>gr", "<cmd>GoRun %<CR>", desc = "Run package" },
            { "<leader>gb", "<cmd>GoBuild .<CR>", desc = "Build package" },

            -- Code analysis
            { "<leader>gal", "<cmd>GoCodeLenAct<CR>", desc = "Code lens" },
            { "<leader>glt", "<cmd>GoLint<CR>", desc = "Lint" },
            { "<leader>gcl", "<cmd>GoClearCoverage<CR>", desc = "Clear coverage" },
            { "<leader>gcv", "<cmd>GoCoverage<CR>", desc = "Toggle coverage" },
            
            -- Debugging
            { "<leader>gdb", "<cmd>GoDebug<CR>", desc = "Start debugger" },
            { "<leader>gdt", "<cmd>GoDebugTest<CR>", desc = "Debug test" },
            { "<leader>gds", "<cmd>GoDebugStop<CR>", desc = "Stop debugger" },
        },
        ft = { "go", "gomod", "gowork", "gotmpl" },
        build = ':lua require("go.install").update_all_sync()',
    },
    {
        "leoluz/nvim-dap-go",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require("dap-go").setup({
                -- Additional dap configurations
                dap_configurations = {
                    {
                        type = "go",
                        name = "Debug Package (with args)",
                        request = "launch",
                        program = "${fileDirname}",
                        args = function()
                            local args = vim.fn.input("Arguments: ")
                            return vim.split(args, " ", true)
                        end,
                    },
                    {
                        type = "go",
                        name = "Test Current Package",
                        request = "launch",
                        mode = "test",
                        program = "./${relativeFileDirname}",
                    },
                },
                delve = {
                    initialize_timeout_sec = 20,
                    port = "${port}",
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { 
                    "gofumpt",      -- Style formatting first
                    "goimports",    -- Handle imports
                    "golines",      -- Line length formatting last
                },
            },
            formatters = {
                golines = {
                    args = { 
                        "--max-len", "120",
                        "--base-formatter", "gofumpt",
                    },
                },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                go = { 
                    "golangcilint",
                    "revive",
                },
            },
            linters = {
                golangcilint = {
                    args = {
                        "run",
                        "--out-format=json",
                        "--enable-all",
                    },
                },
            },
        },
    },
}