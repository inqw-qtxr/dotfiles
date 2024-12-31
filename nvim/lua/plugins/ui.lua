return {
    -- Theme
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            contrast = "hard",
            transparent_mode = false,
        },
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- Git signs
    {
        'lewis6991/gitsigns.nvim',
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = '│' },
                change = { text = '│' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
                untracked = { text = '┆' },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 1000,
            },
        },
    },

    -- Harpoon for quick navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", desc = "Add file to harpoon" },
            { "<leader>hh", desc = "Show harpoon menu" },
            { "<C-h>", desc = "Harpoon file 1" },
            { "<C-j>", desc = "Harpoon file 2" },
            { "<C-k>", desc = "Harpoon file 3" },
            { "<C-l>", desc = "Harpoon file 4" },
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
        end,
    },

    -- Diagnostics viewer
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "TroubleToggle", "Trouble" },
        keys = {
            { "<leader>xx", desc = "Toggle Trouble" },
            { "<leader>xw", desc = "Workspace Diagnostics" },
            { "<leader>xd", desc = "Document Diagnostics" },
        },
        opts = {
            position = "bottom",
            height = 10,
            icons = true,
            mode = "workspace_diagnostics",
            fold_open = "",
            fold_closed = "",
            group = true,
            padding = true,
            action_keys = {
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = {"<cr>", "<tab>"},
                toggle_mode = "m",
                hover = "K",
            },
        },
        config = function(_, opts)
            local trouble = require("trouble")
            trouble.setup(opts)

            vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
            vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
            vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
        end,
    },
}