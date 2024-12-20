-- Core configurations that don't depend on plugins
vim.g.ssl_cert_file = "/opt/homebrew/etc/openssl@3/cert.pem"  -- Adjust path if needed
require("core.settings")  -- vim settings
require("core.keymaps")   -- basic keymaps that don't depend on plugins

-- Initialize lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugins
require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
    rocks = {
        enabled = false,  -- Disable luarocks integration
    }
})

-- Post-plugin commands that need to run after everything is loaded
vim.cmd([[
    colorscheme gruvbox
    filetype plugin indent on
]])