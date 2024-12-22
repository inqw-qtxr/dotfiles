return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                "pyright", -- Python LSP
                "black", -- Python formatter
                "ruff", -- Python linter
                "debugpy", -- Python debugger
                "jedi", -- Optional: Python completion engine
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
                            },
                        },
                    },
                },
                jedi = {}, -- Optionally configure jedi here
            },
        },
        config = function(_, opts)
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup(opts.servers.pyright)
            -- Optionally set up jedi if configured
            if opts.servers.jedi then
                lspconfig.jedi.setup(opts.servers.jedi)
            end
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local mason_registry = require("mason-registry")
            local debugpy_path
            if mason_registry.is_installed("debugpy") then
                debugpy_path = mason_registry.get_package("debugpy"):get_install_path()
                require("dap-python").setup(debugpy_path .. "/venv/bin/python")
                
                -- Configurations for pytest
                require("dap-python").test_runner = "pytest"
                
                -- Configurations for Django and Flask
                require("dap").configurations.python = {
                    {
                        type = "python",
                        request = "launch",
                        name = "Django Runserver",
                        program = "${workspaceFolder}/manage.py",
                        args = { "runserver" },
                        django = true,
                        justMyCode = false,
                    },
                    {
                        type = "python",
                        request = "launch",
                        name = "Flask Run",
                        module = "flask",
                        args = {
                            "run",
                            "--no-debugger",
                            "--no-reload",
                        },
                        env = {
                            FLASK_APP = "${workspaceFolder}/app.py",
                            FLASK_ENV = "development",
                        },
                        justMyCode = false,
                    },
                }
                
                -- Keymaps
                vim.keymap.set("n", "<leader>dpr", function()
                    require("dap-python").test_method()
                end, { desc = "Debug Python Test Method" })
                vim.keymap.set("n", "<leader>dpc", function()
                    require("dap-python").test_class()
                end, { desc = "Debug Python Test Class" })
                vim.keymap.set("n", "<leader>dps", function()
                    require('dap-python').debug_selection()
                end, { desc = "Debug Python Selection" })
                vim.keymap.set("n", "<leader>dpd", function()
                    require("dap").continue({
                        type = "python",
                        request = "launch",
                        program = "${workspaceFolder}/manage.py",
                        args = { "runserver" },
                        django = true,
                        justMyCode = false,
                    })
                end, { desc = "Debug Django Runserver" })
                vim.keymap.set("n", "<leader>dpf", function()
                    require("dap").continue({
                        type = "python",
                        request = "launch",
                        module = "flask",
                        args = {
                            "run",
                            "--no-debugger",
                            "--no-reload",
                        },
                        env = {
                            FLASK_APP = "${workspaceFolder}/app.py",
                            FLASK_ENV = "development",
                        },
                        justMyCode = false,
                    })
                end, { desc = "Debug Flask Run" })
            else
                vim.notify("debugpy is not installed. Please run :Mason and install it.", vim.log.levels.WARN)
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "python",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "black", "ruff" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                python = { "ruff" },
            },
        },
    },
}