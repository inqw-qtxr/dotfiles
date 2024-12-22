-- Barbar Configuration (Enhanced Buffer Line)
return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim',     -- Git integration
        'nvim-tree/nvim-web-devicons', -- File icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        -- Animation and behavior
        animation = true,
        insert_at_end = true,
        focus_on_close = 'previous', -- Focus on the previous buffer when closing current
        hide = { extensions = true }, -- Hide buffer line when only one buffer
        highlight_visible = true,     -- Highlight the buffer you moved to

        -- Icons and visual configuration
        icons = {
            buffer_index = true,
            button = '',
            modified = { button = '●' },
            pinned = { button = '', filename = true },
            separator = { left = '▎', right = '' },
            inactive = { separator = { left = '▎', right = '' } },
            visible = { 
                modified = { button = '●' }
            },
        },

        -- Sidebar configuration
        sidebar_filetypes = {
            ['neo-tree'] = { event = 'BufWipeout' },
            undotree = { event = 'BufWipeout' },
            ['nvim-tree'] = true,
            ['toggleterm'] = { event = 'BufWipeout' },
        },
    },
    config = function()
        local map = vim.keymap.set
        local opts = { noremap = true }

        -- Buffer navigation
        map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { noremap = true, desc = "Previous buffer" })
        map('n', '<A-.>', '<Cmd>BufferNext<CR>', { noremap = true, desc = "Next buffer" })
        
        -- Buffer movement
        map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { noremap = true, desc = "Move buffer left" })
        map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { noremap = true, desc = "Move buffer right" })
        
        -- Direct buffer access (1-9, 0 = last)
        for i = 1, 9 do
            map('n', string.format('<A-%s>', i), 
                string.format('<Cmd>BufferGoto %s<CR>', i),
                { noremap = true, desc = string.format("Go to buffer %s", i) })
        end
        map('n', '<A-0>', '<Cmd>BufferLast<CR>', { noremap = true, desc = "Go to last buffer" })
        
        -- Buffer management
        local function map_buffer_cmd(key, cmd, desc)
            map('n', '<leader>b' .. key, '<Cmd>Buffer' .. cmd .. '<CR>', 
                { noremap = true, desc = desc })
        end

        -- Create/Close operations
        map_buffer_cmd('n', 'new', "Create new buffer")
        map_buffer_cmd('c', 'Close', "Close buffer")
        map_buffer_cmd('x', 'Close', "Close buffer")
        map_buffer_cmd('X', 'CloseAllButCurrentOrPinned', "Close all but current/pinned")
        map_buffer_cmd('L', 'CloseBuffersLeft', "Close all to the left")
        map_buffer_cmd('R', 'CloseBuffersRight', "Close all to the right")
        
        -- Buffer organization
        map_buffer_cmd('p', 'Pin', "Pin/unpin buffer")
        map_buffer_cmd('b', 'OrderByBufferNumber', "Order by buffer number")
        map_buffer_cmd('d', 'OrderByDirectory', "Order by directory")
        map_buffer_cmd('l', 'OrderByLanguage', "Order by language")
        map_buffer_cmd('w', 'OrderByWindowNumber', "Order by window number")

        -- Quick close with Alt+c (separate from leader commands)
        map('n', '<A-c>', '<Cmd>BufferClose<CR>', { noremap = true, desc = "Close buffer" })

        -- Set up highlights (optional)
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = function()
                -- Example highlight customizations
                vim.api.nvim_set_hl(0, 'BufferCurrent', { bold = true })
                vim.api.nvim_set_hl(0, 'BufferVisible', { italic = true })
            end,
        })
    end,
}