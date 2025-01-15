vim.g.mapleader = "\\"

-- general keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit file" })
vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", { desc = "Save and quit file" })
vim.keymap.set("n", "<leader>y", "<cmd>y<CR>", { desc = "Yank" })
vim.keymap.set("n", "<leader>yy", "<cmd>%y<CR>", { desc = "Yank all" })
