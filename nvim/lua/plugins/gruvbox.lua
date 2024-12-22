return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,    -- Load immediately
    priority = 1000, -- Load before other plugins
    opts = {
        -- Core settings
        terminal_colors = true,
        transparent_mode = false,
        dim_inactive = false,
        contrast = "", -- Can be "hard", "soft" or ""

        -- Style settings
        styles = {
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
                headers = true, -- Headers in markdown etc.
            },
            strikethrough = true,
            undercurl = true,
            underline = true,
        },

        -- Behavior settings
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- Invert background for search, diffs, statuslines and errors

        -- Custom highlights
        palette_overrides = {
            -- Example: Customize specific colors
            -- dark0 = "#262626",
            -- light0 = "#fbf1c7",
        },

        -- Override specific highlight groups
        overrides = {
            -- Enhance certain highlight groups
            Search = { bg = "#b8bb26", fg = "#282828" },
            SignColumn = { bg = "NONE" },
            GitSignsAdd = { fg = "#b8bb26", bg = "NONE" },
            GitSignsChange = { fg = "#fabd2f", bg = "NONE" },
            GitSignsDelete = { fg = "#fb4934", bg = "NONE" },
            -- Language-specific overrides
            ["@variable"] = { fg = "#ebdbb2" },
            ["@function"] = { bold = true },
            ["@keyword"] = { italic = true },
            -- UI Elements
            StatusLine = { bg = "#3c3836", fg = "#ebdbb2" },
            StatusLineNC = { bg = "#3c3836", fg = "#928374" },
            TabLine = { bg = "#3c3836", fg = "#928374" },
            TabLineSel = { bg = "#504945", fg = "#ebdbb2" },
            -- Float windows
            NormalFloat = { bg = "#3c3836" },
            FloatBorder = { bg = "#3c3836", fg = "#928374" },
        },
    },
    config = function(_, opts)
        -- Set up colorscheme
        require("gruvbox").setup(opts)

        -- Create autogroup for colorscheme customization
        local group = vim.api.nvim_create_augroup("GruvboxCustom", { clear = true })

        -- Customize colors after colorscheme is loaded
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = group,
            pattern = "gruvbox",
            callback = function()
                -- Additional highlight modifications
                vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
                
                -- Enhance built-in LSP diagnostics
                vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#fb4934" })
                vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#fabd2f" })
                vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#83a598" })
                vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#8ec07c" })
                
                -- Customize indent-blankline
                vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#504945" })
                
                -- Enhance Telescope highlights
                vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#3c3836" })
                vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#32302f" })
                vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#32302f" })
                
                -- Better diff colors
                vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#32361a" })
                vim.api.nvim_set_hl(0, "DiffChange", { bg = "#333841" })
                vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3c1f1e" })
                vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })
            end,
        })

        -- Set colorscheme
        vim.cmd([[colorscheme gruvbox]])

        -- Optional: Commands for toggling theme settings
        vim.api.nvim_create_user_command("ToggleTransparent", function()
            opts.transparent_mode = not opts.transparent_mode
            require("gruvbox").setup(opts)
            vim.cmd([[colorscheme gruvbox]])
        end, { desc = "Toggle transparent background" })

        vim.api.nvim_create_user_command("ToggleContrast", function()
            local contrasts = { "", "soft", "hard" }
            local current = vim.tbl_contains(contrasts, opts.contrast) and opts.contrast or ""
            local idx = (vim.tbl_contains(contrasts, current) and vim.fn.index(contrasts, current) or 0) + 1
            if idx > #contrasts then idx = 1 end
            opts.contrast = contrasts[idx]
            require("gruvbox").setup(opts)
            vim.cmd([[colorscheme gruvbox]])
            vim.notify("Contrast set to: " .. (opts.contrast == "" and "medium" or opts.contrast))
        end, { desc = "Toggle contrast level" })
    end,
}