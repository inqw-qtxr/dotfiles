-- Set the leader key to backslash
vim.g.mapleader = "\\"

-- Ensure escape works in all modes
vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true })
vim.keymap.set('v', '<Esc>', '<Esc>', { noremap = true })
vim.keymap.set('x', '<Esc>', '<Esc>', { noremap = true })

-- Window Management
vim.keymap.set("n", "<leader>.", ":cd %:p:h<CR>:pwd<CR>", { noremap = true, desc = "Change directory to current file" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { noremap = true, desc = "Split horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { noremap = true, desc = "Make splits equal size" })

-- Quality of Life
vim.keymap.set("n", "gV", "`[v`]", { noremap = true, desc = "Select last inserted text" })
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { noremap = true, desc = "Change directory to current file" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { noremap = true, desc = "Yank line to system clipboard" })

-- Quick Save & Quit
vim.keymap.set("n", "<leader>w", ":write<CR>", { noremap = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { noremap = true, desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { noremap = true, desc = "Save & Quit" })

-- Reload Config
vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>", { noremap = true, desc = "Reload configuration" })