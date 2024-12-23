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

    -- Language Support
    { import = "plugins.ruby" },
    { "tpope/vim-rails" },
    { import = "plugins.go" },
    { import = "plugins.cpp" },

    -- Core Features
    { "mbbill/undotree" },
    { "nvim-tree/nvim-tree.lua" },
    { "github/copilot.vim" },

    -- Telescope and Dependencies
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

    -- Editor Enhancement
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Debugging
    { "mfussenegger/nvim-dap" },
    { "mfussenegger/nvim-dap-python" },

    -- Git Integration
    { "lewis6991/gitsigns.nvim" },

    -- Testing
    { "vim-test/vim-test" },

    -- Theme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "hard",
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },

    -- Buffer Management
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            animation = true,
            insert_at_end = true,
            icons = {
                buffer_index = true,
                button = '',
                modified = { button = '●' },
                pinned = { button = '', filename = true },
                separator = { left = '▎', right = '' },
            },
        },
    },

    -- Markdown
    { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end },

    -- vim-cool for search highlight removal
    { "romainl/vim-cool" },
})
