return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        keys = { 
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } 
        },
        opts = {
            ensure_installed = {
                -- LSP
                "pyright",          -- Static type checker
                "ruff-lsp",        -- Fast linter/formatter
                "python-lsp-server", -- Alternative full-featured LSP
                -- DAP
                "debugpy",         -- Debug adapter
                -- Linters
                "ruff",            -- Fast linter
                "mypy",            -- Static type checker
                -- Formatters
                "black",           -- Code formatter
                "isort",           -- Import formatter
                -- Extra tools
                "pytest",          -- Testing
                "python-rope",     -- Refactoring library
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
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "workspace",
                                -- Additional analysis settings
                                autoImportCompletions = true,
                                diagnosticSeverityOverrides = {
                                    reportUnusedVariable = "warning",
                                    reportGeneralTypeIssues = "warning",
                                },
                                -- Environment settings
                                venvPath = ".",
                                pythonPath = nil, -- Will be automatically detected
                            },
                        },
                    },
                },
                ruff_lsp = {
                    init_options = {
                        settings = {
                            -- Ruff settings
                            args = {},
                        }
                    }
                },
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                -- Plugin settings
                                pycodestyle = { enabled = false },
                                mccabe = { enabled = false },
                                pyflakes = { enabled = false },
                                pylint = { enabled = false },
                                yapf = { enabled = false },
                                autopep8 = { enabled = false },
                                -- Enable rope for refactoring
                                rope_completion = { enabled = true },
                                rope_autoimport = { enabled = true },
                            }
                        }
                    }
                }
            },
            setup = {
                pyright = function(_, opts)
                    require("lspconfig").pyright.setup(opts)
                end,
                ruff_lsp = function(_, opts)
                    require("lspconfig").ruff_lsp.setup(opts)
                end,
                pylsp = function(_, opts)
                    require("lspconfig").pylsp.setup(opts)
                end,
            },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        keys = {
            { 
                "<leader>dpr", 
                function() require("dap-python").test_method() end, 
                desc = "Debug Python Test Method" 
            },
            { 
                "<leader>dpc", 
                function() require("dap-python").test_class() end, 
                desc = "Debug Python Test Class" 
            },
            { 
                "<leader>dps", 
                function() require("dap-python").debug_selection() end, 
                desc = "Debug Python Selection" 
            },
            { 
                "<leader>dpd", 
                function() 
                    require("dap").continue({
                        type = "python",
                        request = "launch",
                        program = "${workspaceFolder}/manage.py",
                        args = { "runserver" },
                        django = true,
                        justMyCode = false,
                    })
                end, 
                desc = "Debug Django Server" 
            },
            { 
                "<leader>dpf", 
                function() 
                    require("dap").continue({
                        type = "python",
                        request = "launch",
                        module = "flask",
                        args = { "run", "--no-debugger", "--no-reload" },
                        env = {
                            FLASK_APP = "${workspaceFolder}/app.py",
                            FLASK_ENV = "development",
                        },
                        justMyCode = false,
                    })
                end, 
                desc = "Debug Flask Server" 
            },
        },
        config = function()
            local path = require("mason-registry").get_package("debugpy"):get_install_path()
            require("dap-python").setup(path .. "/venv/bin/python")
            require("dap-python").test_runner = "pytest"

            -- Additional configurations
            local dap = require("dap")
            dap.configurations.python = vim.list_extend(dap.configurations.python or {}, {
                {
                    type = "python",
                    request = "launch",
                    name = "FastAPI",
                    module = "uvicorn",
                    args = {
                        "main:app",
                        "--reload",
                    },
                    justMyCode = false,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Python: Current File",
                    program = "${file}",
                    console = "integratedTerminal",
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Python: Django Tests",
                    program = "${workspaceFolder}/manage.py",
                    args = { "test" },
                    django = true,
                    justMyCode = false,
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "python", "ninja", "rst", "toml" },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = {
                    "isort",   -- Handle imports
                    "black",   -- Code formatting
                    "ruff",    -- Fast formatting for remaining issues
                },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                python = {
                    "ruff",
                    "mypy",
                },
            },
            -- Configure linters
            linters = {
                mypy = {
                    args = {
                        "--ignore-missing-imports",
                        "--disallow-untyped-defs",
                        "--check-untyped-defs",
                        "--disallow-any-generics",
                        "--no-implicit-optional",
                        "--warn-redundant-casts",
                        "--warn-unused-ignores",
                        "--warn-return-any",
                        "--warn-unreachable",
                    },
                },
            },
        },
    },
}