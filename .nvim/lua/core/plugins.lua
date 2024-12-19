-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Setup
require("lazy").setup({
    -- Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground" }, -- Additional Treesitter tools

    -- Undo tree
    { "mbbill/undotree" },

    -- Telescope for file searching
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            { "nvim-telescope/telescope-media-files.nvim" },
            { "nvim-telescope/telescope-project.nvim" },
            { "nvim-telescope/telescope-symbols.nvim" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                    mappings = {
                        i = {
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                        },
                    },
                },
            })
        end,
    },

    -- LSP (Language Server Protocol)
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Formatters and Linters
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Statusline
    "nvim-lualine/lualine.nvim",

    -- File Explorer
    { "nvim-tree/nvim-tree.lua" },

    -- Git Integration
    { "lewis6991/gitsigns.nvim" },

    -- Testing
    { "vim-test/vim-test" },

    -- Gruvbox Theme
    { "ellisonleao/gruvbox.nvim" },

    -- GitHub Copilot
    { "github/copilot.vim" },

    -- Add any additional plugins here
    -- Avoid duplicating plugins already set by separate config files
})

