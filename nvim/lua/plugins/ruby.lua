return {
    {
        "tpope/vim-rails",
        dependencies = {
            "tpope/vim-bundler",
            "tpope/vim-projectionist"
        },
        config = function()
            -- Rails specific keymaps
            vim.keymap.set("n", "<leader>ra", ":A<CR>", { desc = "Alternate file" })
            vim.keymap.set("n", "<leader>rm", ":Emodel<CR>", { desc = "Jump to model" })
            vim.keymap.set("n", "<leader>rc", ":Econtroller<CR>", { desc = "Jump to controller" })
            vim.keymap.set("n", "<leader>rv", ":Eview<CR>", { desc = "Jump to view" })
            vim.keymap.set("n", "<leader>rh", ":Ehelper<CR>", { desc = "Jump to helper" })
            vim.keymap.set("n", "<leader>rt", ":Etest<CR>", { desc = "Jump to test" })
        end,
    },
    {
        "tpope/vim-rails",
        dependencies = { "tpope/vim-bundler", "tpope/vim-projectionist" },
    },
    {
        "RRethy/nvim-treesitter-endwise",
        config = function()
            require("nvim-treesitter-endwise")
        end,
    },
    {
        "tpope/vim-rake",
    },
    {
        "tpope/vim-bundler",
    },
    {
        "slim-template/vim-slim",
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            -- Configure Ruby/Rails specific notifications
            vim.notify = require("notify")
            vim.notify.setup({
                stages = "fade",
                timeout = 3000,
                background_colour = "#000000",
            })
        end,
    },
}

