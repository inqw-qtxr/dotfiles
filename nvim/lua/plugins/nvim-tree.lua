return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            select_prompts = true,
            disable_netrw = true,
            hijack_directories = {
                enable = true,
                auto_open = false,
            },
            sort_by = "case_sensitive",
            view = {
                width = 30,
                adaptive_size = false,
            },
            renderer = {
                group_empty = true,
                highlight_git = true,
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
            filters = {
                dotfiles = false,
            },
            git = {
                enable = true,
                ignore = false,
            },
            actions = {
                open_file = {
                    quit_on_open = false,
                    window_picker = {
                        enable = true,
                    },
                },
            },
            update_focused_file = {
                enable = true,
                update_root = false,
            },
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
    end,
}
