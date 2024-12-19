vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.guifont = "FiraCode Nerd Font:h12"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000
vim.opt.statusline = "%f %y %r %m %=%l,%c %p%%"
-- Ensure no delays for escape key
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
-- Ensure escape key works properly in terminal