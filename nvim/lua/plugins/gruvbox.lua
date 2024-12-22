return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,    -- Load immediately
    priority = 1000, -- Load before other plugins
    opts = {
        -- Core settings
        terminal_colors = true,
        transparent_mode = false,
        dim_inactive = false,
        contrast = "medium", -- Use medium contrast

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
        palette_overrides = {},

        -- Override specific highlight groups
        overrides = {
            -- UI Elements with medium contrast
            SignColumn = { bg = "NONE" },
            GruvboxGreenSign = { fg = "#b8bb26", bg = "NONE" },
            GruvboxAquaSign = { fg = "#8ec07c", bg = "NONE" },
            GruvboxRedSign = { fg = "#fb4934", bg = "NONE" },
            
            -- Enhanced visibility for medium contrast
            Search = { bg = "#a89984", fg = "#282828" },
            Visual = { bg = "#504945" },
            
            -- Status line with medium contrast
            StatusLine = { bg = "#504945", fg = "#ebdbb2" },
            StatusLineNC = { bg = "#3c3836", fg = "#a89984" },
            
            -- Better float windows
            NormalFloat = { bg = "#3c3836" },
            FloatBorder = { bg = "#3c3836", fg = "#a89984" },

            -- Git signs with medium contrast
            GitSignsAdd = { fg = "#b8bb26", bg = "NONE" },
            GitSignsChange = { fg = "#fabd2f", bg = "NONE" },
            GitSignsDelete = { fg = "#fb4934", bg = "NONE" },

            -- Diagnostics with medium contrast
            DiagnosticError = { fg = "#fb4934" },
            DiagnosticWarn = { fg = "#fabd2f" },
            DiagnosticInfo = { fg = "#83a598" },
            DiagnosticHint = { fg = "#8ec07c" },

            -- Better diff colors
            DiffAdd = { bg = "#3b4439" },
            DiffChange = { bg = "#3b4439" },
            DiffDelete = { bg = "#442b2a" },
            DiffText = { bg = "#345657" }
        }
    },
    config = function(_, opts)
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
            local contrasts = { "soft", "medium", "hard" }
            local current_idx = vim.fn.index(contrasts, opts.contrast) + 1
            if current_idx > #contrasts then current_idx = 1 end
            opts.contrast = contrasts[current_idx]
            require("gruvbox").setup(opts)
            vim.cmd([[colorscheme gruvbox]])
            vim.notify("Contrast set to: " .. opts.contrast)
        end, { desc = "Toggle contrast level" })
    end,
}