vim.g.mapleader = "\\"

-- general keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit file" })
vim.keymap.set("n", "<leader>yy", "<cmd>%y<CR>", { desc = "Yank all" })

-- split navigation
--create new vertical split
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>s+", "<C-w>+", { desc = "Increase split size" })
vim.keymap.set("n", "<leader>s-", "<C-w>-", { desc = "Decrease split size" })
vim.keymap.set("n", "<leader>s=", "<C-w>=", { desc = "Equalize split size" })
