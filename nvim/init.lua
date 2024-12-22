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
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("Error: Colorscheme " .. colorscheme .. " not found!", vim.log.levels.WARN)
    -- Try to set a fallback colorscheme
    local fallback_colorscheme = "desert"
    local fallback_status = pcall(vim.cmd, "colorscheme " .. fallback_colorscheme)
    if not fallback_status then
        vim.notify("Error: Fallback colorscheme also failed to load!", vim.log.levels.ERROR)
    end
end

vim.cmd('filetype plugin indent on')