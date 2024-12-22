-- Visual Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.guifont = "FiraCode Nerd Font:h12"
vim.opt.colorcolumn = "80"

-- Indentation and Formatting
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search and Case Sensitivity
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- System Integration
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Undo Settings
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Timing and Timeout
vim.opt.timeout = false
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- Status Line
vim.opt.statusline = "%f %y %r %m %=%l,%c %p%%"

-- Python Configuration
vim.g.python3_host_prog = vim.fn.exepath('python3') -- Use system Python for Neovim

-- Language-Specific Settings
-- Python
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

-- Go
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        -- Use tabs for Go files as per Go standards
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.textwidth = 120
        -- Enable format on save for Go files
        vim.opt_local.formatoptions:append('q')
    end,
})