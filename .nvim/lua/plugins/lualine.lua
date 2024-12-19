return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                theme = "gruvbox",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    { "filename", path = 2 },
                    {
                        "diagnostics",
                        sources = { "nvim_lsp" },
                        symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {}
            },
        })
    end,
    dependencies = {
        "ellisonleao/gruvbox.nvim", -- Make sure gruvbox theme is available
    },
}
