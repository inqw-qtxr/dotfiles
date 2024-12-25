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

            -- List of special shell config files with relaxed checking
            local special_files = {
                ['.env'] = true,
                ['.env.local'] = true,
                ['.env.development'] = true,
                ['.env.production'] = true,
                ['.env.test'] = true,
                ['.bashrc'] = true,
                ['.zshrc'] = true,
                ['.bash_profile'] = true,
                ['.zsh_profile'] = true,
                ['.zshenv'] = true,
                ['.bash_aliases'] = true,
                ['.zsh_aliases'] = true,
            }

            -- Function to check if file is a special config file
            local function is_special_file()
                local filename = vim.fn.expand('%:t')
                return special_files[filename] or false
            end

            -- Shell-specific keymaps
            local function setup_shell_keymaps(bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                
                -- Shell-specific actions
                vim.keymap.set("n", "<leader>sx", "<cmd>!chmod +x %<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Make executable" }))
                vim.keymap.set("n", "<leader>sr", "<cmd>!./%<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Run script" }))
                
                -- Only add shellcheck command for non-special files
                if not is_special_file() then
                    vim.keymap.set("n", "<leader>sc", "<cmd>!shellcheck %<CR>", 
                        vim.tbl_extend("force", opts, { desc = "Run shellcheck" }))
                end
            end

            -- Bash LSP configuration with relaxed rules for config files
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

                    -- Disable diagnostics for special files
                    if is_special_file() then
                        vim.diagnostic.disable(bufnr)
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

                    -- Add shell script specific comments
                    vim.opt_local.commentstring = "# %s"

                    -- Improved syntax highlighting for heredocs
                    vim.opt_local.iskeyword:append("-")
                end,
            })

            -- Configure shellcheck diagnostics with relaxed rules for config files
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.sh", "*.bash", "*.zsh", "*.fish" },
                callback = function()
                    -- Skip shellcheck completely for special configuration files
                    if is_special_file() then
                        return
                    end

                    local filename = vim.fn.expand("%:p")
                    -- Run shellcheck with specific exclusions for common config patterns
                    local command = string.format(
                        "shellcheck -e SC1090,SC1091,SC2034,SC2086,SC2155,SC2164 %s",
                        filename
                    )
                    local output = vim.fn.system(command)
                    
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