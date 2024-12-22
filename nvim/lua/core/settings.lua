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
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Python specific settings
vim.g.python3_host_prog = vim.fn.exepath('python3') -- Use system Python for Neovim
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

-- Add Python specific autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.colorcolumn = "88"  -- Black's default line length
        vim.opt_local.textwidth = 88
    end,
})