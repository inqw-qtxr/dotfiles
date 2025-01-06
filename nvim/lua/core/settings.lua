-- Editor Behavior
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.hlsearch = false

-- System
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

-- Status
vim.opt.statusline = "%f %y %r %m %=%l,%c %p%%"

-- Timing
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
