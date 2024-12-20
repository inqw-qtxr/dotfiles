return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Ensure colorscheme loads before other plugins
    config = function()
        require("gruvbox").setup({
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
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
            contrast = "soft",
            palette_overrides = {
                bright_green = "#a9b665",
            },
            overrides = {
                SignColumn = { bg = "NONE" },
                GruvboxGreenSign = { bg = "NONE" },
                GruvboxAquaSign = { bg = "NONE" },
                GruvboxRedSign = { bg = "NONE" },
            },
            dim_inactive = false,
            transparent_mode = false,
        })
        vim.cmd.colorscheme("gruvbox")
    end,
}
