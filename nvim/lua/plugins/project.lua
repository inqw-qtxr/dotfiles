return {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy", -- Load the plugin lazily
    dependencies = { 
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- Add explicit dependency for stability
    },
    keys = {
        -- Define keymaps in a structured way
        {
            "<leader>fp",
            "<cmd>Telescope projects<cr>",
            desc = "Find projects"
        },
        {
            "<leader>fa",
            function()
                local project = require("project_nvim")
                project.add_project()
            end,
            desc = "Add project manually"
        },
    },
    opts = {
        -- Using opts table for better lazy.nvim integration
        detection_methods = { 
            "pattern",     -- Pattern-based detection
            "lsp",        -- LSP-based detection
            "git",        -- Git-based detection
        },
        -- Extended patterns for better project detection
        patterns = { 
            ".git",
            "Makefile",
            "package.json",
            "go.mod",
            "Cargo.toml",
            "composer.json",    -- PHP projects
            "requirements.txt", -- Python projects
            "build.gradle",    -- Gradle projects
            ".project.nvim"    -- Custom project marker
        },
        -- Additional configuration options
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        update_focused_file = {
            enable = true,
            update_cwd = true
        },
        -- Exclude directories from project detection
        ignore_dirs = {
            "~",
            "~/Downloads",
            "/tmp",
            "node_modules",
        },
    },
    config = function(_, opts)
        local project = require("project_nvim")
        project.setup(opts)

        -- Load telescope extension
        require('telescope').load_extension('projects')

        -- Add custom commands
        vim.api.nvim_create_user_command("ProjectRoot", function()
            vim.cmd("cd " .. project.get_project_root())
        end, { desc = "Change directory to project root" })

        -- Optional: Set up autocommands
        local group = vim.api.nvim_create_augroup("ProjectNvim", { clear = true })
        vim.api.nvim_create_autocmd("VimEnter", {
            group = group,
            callback = function()
                local path = vim.fn.expand("%:p:h")
                if vim.fn.isdirectory(path) == 1 then
                    project.set_pwd(path, "current")
                end
            end,
            desc = "Set project directory on startup"
        })
    end,
}