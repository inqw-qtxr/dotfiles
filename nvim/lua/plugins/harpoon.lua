return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        -- Keymaps
        vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Add file to harpoon" })
        vim.keymap.set("n", "<leader>he", ui.toggle_quick_menu, { desc = "Show harpoon menu" })

        -- Quick navigation to harpoon marks
        vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = "Navigate to harpoon 1" })
        vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, { desc = "Navigate to harpoon 2" })
        vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, { desc = "Navigate to harpoon 3" })
        vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, { desc = "Navigate to harpoon 4" })
    end,
}