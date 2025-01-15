-- general editor settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- system settings
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undolevels = 10000 -- no need for undoreload when undolevels is set

-- timing settings and quality of life
vim.opt.timeout = false -- These two are likely not what you want, as they disable
vim.opt.ttimeout = false -- mapping timeouts. Consider removing them.
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0 -- ttimeoutlen should be greater than zero to avoid input lag.

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

