vim.g.ssl_cert_file = "/opt/homebrew/etc/openssl@3/cert.pem"

require("core.settings") 
require("core.keymaps")

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

require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
    rocks = {
        enabled = false,
    }
})



local colorscheme = "gruvbox"
vim.cmd("colorscheme " .. colorscheme)

vim.cmd('filetype plugin indent on')