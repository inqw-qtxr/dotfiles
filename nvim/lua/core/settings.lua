-- Editor Behavior
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

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

-- Add Python specific autocommands
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.colorcolumn = "88"  -- Black's default line length
        vim.opt_local.textwidth = 88
    end,
})

-- Go specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        -- Use tabs for Go files as per Go standards
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        -- Set textwidth for Go files
        vim.bo.textwidth = 120
        -- Enable format on save for Go files
        vim.opt_local.formatoptions:append('q')
    end,
})