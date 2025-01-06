-- Set the leader key to backslash
vim.g.mapleader = "\\"

-- Quality of Life
vim.keymap.set("n", "gV", "`[v`]", { noremap = true, desc = "Select last inserted text" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, desc = "Quit" })
vim.keymap.set("n", "<leader>yy", ":%y+<CR>", { noremap = true, desc = "Yank entire file" })

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })