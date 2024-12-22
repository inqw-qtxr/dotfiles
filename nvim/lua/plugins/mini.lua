return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Enable indent scope visualization
        require('mini.indentscope').setup({
            symbol = '│',
            options = { try_as_border = true },
        })

        -- Enable better animations
        require('mini.animate').setup({
            cursor = { enable = true },
            scroll = { enable = true },
        })

        -- Add file info in statusline
        require('mini.statusline').setup({
            use_icons = true,
        })

        -- Add better text alignment
        require('mini.align').setup({
            mappings = {
                start = 'ga',
                start_with_preview = 'gA',
            },
        })
    end,
}