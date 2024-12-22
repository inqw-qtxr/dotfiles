return {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            detection_methods = { "pattern", "lsp" },
            patterns = { ".git", "Makefile", "package.json", "go.mod", "Cargo.toml" },
            show_hidden = false,
            silent_chdir = true,
            scope_chdir = 'global',
            
            -- Automatically add projects to telescope
            on_config_done = function()
                require('telescope').load_extension('projects')
            end,
        })

        -- Add keymap for project navigation
        vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>",
            { noremap = true, desc = "Find projects" })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
}