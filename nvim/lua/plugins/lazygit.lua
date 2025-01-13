return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        -- Setup telescope integration
        require("telescope").load_extension("lazygit")

        -- Keymaps for LazyGit
        vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
        vim.keymap.set("n", "<leader>gG", "<cmd>Telescope lazygit<CR>", { desc = "Open LazyGit with Telescope" })
    end,
}