return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- Set up keymaps before configuring nvim-tree
        vim.keymap.set("n", "<leader>E", ":NvimTreeToggle<CR>", { noremap = true, desc = "Toggle file explorer" })
        vim.keymap.set("n", "<leader>F", ":NvimTreeFocus<CR>", { noremap = true, desc = "Focus file explorer" })
        
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                width = 30,
                side = "left",
                number = false,
                relativenumber = false,
                signcolumn = "yes",
            },
            renderer = {
                group_empty = true,
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
                dotfiles = true,
                custom = {},
                exclude = {},
            },
            git = {
                enable = true,
                ignore = true,
                timeout = 400,
            },
            actions = {
                use_system_clipboard = true,
                change_dir = {
                    enable = true,
                    global = false,
                    restrict_above_cwd = false,
                },
                open_file = {
                    quit_on_open = false,
                    resize_window = false,
                    window_picker = {
                        enable = true,
                    },
                },
            },
        })
    end,
}