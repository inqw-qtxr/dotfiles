return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",           -- C/C++ LSP
                "clang-format",     -- C/C++ formatter
                "codelldb",         -- C/C++ debugger
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", "."),
                init_options = {
                    clangd = {
                        fallbackFlags = {
                            "-std=c++17",
                        },
                    },
                },
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.c = { "clang-format" }
            opts.formatters_by_ft.cpp = { "clang-format" }
            return opts
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local dap = require("dap")
            dap.adapters.codelldb = {
                type = "server",
                port = "\\${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "\\${port}" },
                },
            }
            dap.configurations.c = {
                {
                    name = "Launch C",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. [[/]], "file")
                    end,
                    cwd = [[${workspaceFolder}]],
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.cpp = {
                {
                    name = "Launch C++",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. [[/]], "file")
                    end,
                    cwd = [[${workspaceFolder}]],
                    stopOnEntry = false,
                    args = {},
                },
            }
        end,
    },
}