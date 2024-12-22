return {
    -- Mason configuration for shell script tools
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            -- Essential shell development tools
            local tools = {
                "shellcheck",         -- Shell script static analysis tool
                "shfmt",             -- Shell formatter
                "bash-language-server", -- LSP for shell scripting
                "bash-debug-adapter", -- Debug adapter for bash scripts
            }

            -- Ensure all tools are installed
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, tools)
        end,
    },

    -- LSP configuration for shell scripting
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- Shell-specific keymaps
            local function setup_shell_keymaps(bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                
                -- Shell-specific actions
                vim.keymap.set("n", "<leader>sx", "<cmd>!chmod +x %<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Make executable" }))
                vim.keymap.set("n", "<leader>sr", "<cmd>!./%<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Run script" }))
                vim.keymap.set("n", "<leader>sc", "<cmd>!shellcheck %<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Run shellcheck" }))
            end

            -- Shell script formatting configuration
            local function setup_shell_formatting(bufnr)
                local shfmt_args = {
                    "-i", "4",     -- Use 4 spaces for indentation
                    "-bn",         -- Binary ops like && and | may start a line
                    "-ci",         -- Switch cases will be indented
                    "-sr",         -- Keep space after redirect operators
                }

                vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                    vim.cmd(string.format("!shfmt -w %s %s", table.concat(shfmt_args, " "), vim.fn.expand("%")))
                    vim.notify("Formatted shell script", vim.log.levels.INFO)
                end, { desc = "Format shell script" })
            end

            -- Bash LSP configuration
            lspconfig.bashls.setup({
                filetypes = { "sh", "bash", "zsh", "fish" },
                settings = {
                    bashIde = {
                        -- Enhanced LSP settings
                        shellcheckPath = vim.fn.exepath("shellcheck"),
                        enableSourceErrorDiagnostics = true,
                        globPattern = "*@(.sh|.inc|.bash|.command)",
                        includeAllWorkspaceSymbols = true,
                    },
                },
                on_attach = function(client, bufnr)
                    -- Setup shell-specific keymaps
                    setup_shell_keymaps(bufnr)
                    
                    -- Setup formatting
                    setup_shell_formatting(bufnr)

                    -- Enable inlay hints if supported
                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(bufnr, true)
                    end
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Set up autocommands for shell scripts
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sh", "bash", "zsh", "fish" },
                callback = function()
                    -- Set shell script specific options
                    vim.opt_local.expandtab = true
                    vim.opt_local.shiftwidth = 4
                    vim.opt_local.tabstop = 4
                    vim.opt_local.softtabstop = 4

                    -- Format on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = 0,
                        callback = function()
                            vim.cmd("Format")
                        end,
                    })

                    -- Add shell script specific comments
                    vim.opt_local.commentstring = "# %s"

                    -- Improved syntax highlighting for heredocs
                    vim.opt_local.iskeyword:append("-")
                end,
            })

            -- Configure shellcheck diagnostics
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.sh", "*.bash", "*.zsh", "*.fish" },
                callback = function()
                    local filename = vim.fn.expand("%:p")
                    local output = vim.fn.system("shellcheck " .. filename)
                    
                    if vim.v.shell_error ~= 0 then
                        vim.notify(output, vim.log.levels.WARN, {
                            title = "ShellCheck Warnings",
                            timeout = 5000,
                        })
                    end
                end,
            })
        end,
    },
}