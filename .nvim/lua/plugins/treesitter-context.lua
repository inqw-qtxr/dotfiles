return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("treesitter-context").setup({
            enable = true,
            max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 20, -- Maximum number of lines to show for a single context
            trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
            separator = nil,
            zindex = 20,             -- The Z-index of the context window
            patterns = {             -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                default = {
                    'class',
                    'function',
                    'method',
                    'for',
                    'while',
                    'if',
                    'switch',
                    'case',
                },
            },
        })

        -- Keymaps for controlling context
        vim.keymap.set("n", "[c", function()
            require("treesitter-context").go_to_context()
        end, { silent = true, desc = "Go to context" })

        vim.keymap.set("n", "<leader>tc", function()
            require("treesitter-context").toggle()
        end, { silent = true, desc = "Toggle treesitter context" })
    end,
}