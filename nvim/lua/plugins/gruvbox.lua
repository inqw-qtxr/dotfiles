return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,    -- Load immediately
    priority = 1000, -- Load before other plugins
    opts = {
        -- Core settings
        terminal_colors = true,
        transparent_mode = false,
        contrast = "hard", -- Can be "hard", "soft", or "" (empty string for medium)

        -- Basic style settings
        italic = {
            strings = false,
            comments = true,
            operators = false,
            folds = true,
        },
        bold = true,
        underline = true,
        undercurl = true,
    },
    config = function(_, opts)
        require("gruvbox").setup(opts)
        vim.cmd([[colorscheme gruvbox]])
    end,
}