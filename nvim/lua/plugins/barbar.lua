return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    version = '^1.0.0',
    event = 'VimEnter',
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        -- Animation and behavior
        animation = true,
        auto_hide = false,
        tabpages = true,
        clickable = true,
        exclude_ft = { 'qf' }, -- Exclude quickfix windows
        exclude_name = { 'package.json', 'LICENSE' },
        focus_on_close = 'previous',
        hide = {
            extensions = true,
            inactive = false,
            current = false,
            visible = false,
        },
        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,
        icons = {
            buffer_index = true,
            buffer_number = false,
            button = '',
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = {enabled = true},
                [vim.diagnostic.severity.WARN] = {enabled = true},
                [vim.diagnostic.severity.INFO] = {enabled = true},
                [vim.diagnostic.severity.HINT] = {enabled = true},
            },
            gitsigns = {
                added = {enabled = true, icon = '+'},
                changed = {enabled = true, icon = '~'},
                deleted = {enabled = true, icon = '-'},
            },
            filetype = {
                custom_colors = false,
                enabled = true,
            },
            modified = {button = '●'},
            pinned = {button = '', filename = true},
            separator = {left = '▎', right = ''},
            inactive = {separator = {left = '▎', right = ''}},
            visible = {modified = {button = '●'}},
            alternate = {filetype = {enabled = false}},
        },
        insert_at_start = false,
        insert_at_end = true,
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        semantic_letters = true,
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
        no_name_title = '[No Name]',
        sidebar_filetypes = {
            ['neo-tree'] = {event = 'BufWipeout'},
            undotree = {event = 'BufWipeout'},
            ['nvim-tree'] = true,
            ['toggleterm'] = {event = 'BufWipeout'},
            ['dapui_.*'] = true, -- Support for DAP UI
            ['aerial'] = true,  -- Support for aerial (symbols outline)
            ['trouble'] = true, -- Support for trouble.nvim
        },
    },
    config = function()
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true } -- Add silent = true

        -- Buffer navigation with improved descriptions
        map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', vim.tbl_extend('force', opts, {desc = "Previous buffer"}))
        map('n', '<A-.>', '<Cmd>BufferNext<CR>', vim.tbl_extend('force', opts, {desc = "Next buffer"}))
        map('n', '<A-p>', '<Cmd>BufferPick<CR>', vim.tbl_extend('force', opts, {desc = "Pick buffer"}))

        -- Buffer movement
        map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', vim.tbl_extend('force', opts, {desc = "Move buffer left"}))
        map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', vim.tbl_extend('force', opts, {desc = "Move buffer right"}))

        -- Direct buffer access (1-9, 0 = last)
        for i = 1, 9 do
            map('n', string.format('<A-%s>', i),
                string.format('<Cmd>BufferGoto %s<CR>', i),
                vim.tbl_extend('force', opts, {desc = string.format("Go to buffer %s", i)}))
        end
        map('n', '<A-0>', '<Cmd>BufferLast<CR>', vim.tbl_extend('force', opts, {desc = "Go to last buffer"}))

        -- Buffer management with improved function
        local function map_buffer_cmd(key, cmd, desc)
            map('n', '<leader>b' .. key, '<Cmd>Buffer' .. cmd .. '<CR>',
                vim.tbl_extend('force', opts, {desc = desc}))
        end

        -- Enhanced buffer operations
        map_buffer_cmd('n', 'new', "Create new buffer")
        map_buffer_cmd('c', 'Close', "Close buffer")
        map_buffer_cmd('x', 'Close', "Close buffer")
        map_buffer_cmd('X', 'CloseAllButCurrentOrPinned', "Close all but current/pinned")
        map_buffer_cmd('L', 'CloseBuffersLeft', "Close all to the left")
        map_buffer_cmd('R', 'CloseBuffersRight', "Close all to the right")
        map_buffer_cmd('a', 'CloseAllButPinned', "Close all but pinned")
        map_buffer_cmd('p', 'Pin', "Pin/unpin buffer")
        map_buffer_cmd('b', 'OrderByBufferNumber', "Order by buffer number")
        map_buffer_cmd('d', 'OrderByDirectory', "Order by directory")
        map_buffer_cmd('l', 'OrderByLanguage', "Order by language")
        map_buffer_cmd('w', 'OrderByWindowNumber', "Order by window number")
        map_buffer_cmd('r', 'Restore', "Restore closed buffer")

        map('n', '<A-c>', '<Cmd>BufferClose<CR>', vim.tbl_extend('force', opts, {desc = "Close buffer"}))
        map('n', '<A-s>', '<Cmd>BufferPick<CR>', vim.tbl_extend('force', opts, {desc = "Pick buffer"}))

        -- Set up highlights with more customization
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = function()
                local highlights = {
                    BufferCurrent = { bold = true, fg = '#ffffff', bg = '#394b70' },
                    BufferVisible = { italic = true },
                    BufferInactive = { fg = '#808080' },
                    BufferCurrentMod = { bold = true, fg = '#f0c674' },
                    BufferVisibleMod = { italic = true, fg = '#f0c674' },
                    BufferInactiveMod = { fg = '#d9a76f' },
                    BufferCurrentSign = { fg = '#394b70' },
                    BufferVisibleSign = { fg = '#394b70' },
                    BufferInactiveSign = { fg = '#606060' },
                }

                for group, settings in pairs(highlights) do
                    vim.api.nvim_set_hl(0, group, settings)
                end
            end,
        })

        local augroup = vim.api.nvim_create_augroup('BarbarCustom', {clear = true})
        
        -- Auto-close empty buffers when leaving them
        vim.api.nvim_create_autocmd('BufLeave', {
            group = augroup,
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.api.nvim_buf_get_name(bufnr) == '' and
                   vim.api.nvim_buf_line_count(bufnr) <= 1 and
                   vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == '' then
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            vim.api.nvim_buf_delete(bufnr, {force = false})
                        end
                    end)
                end
            end,
        })
    end,
}