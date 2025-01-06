return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        local comment = require("Comment")
        
        -- Load ts_context_commentstring integration
        require('ts_context_commentstring').setup({
            enable_autocmd = false,
            languages = {
                typescript = { __default = '// %s', __multiline = '/* %s */' },
                javascript = { __default = '// %s', __multiline = '/* %s */' },
                lua = { __default = '-- %s', __multiline = '--[[ %s ]]' },
                css = { __default = '/* %s */', __multiline = '/* %s */' },
                scss = { __default = '/* %s */', __multiline = '/* %s */' },
                html = { __default = '<!-- %s -->', __multiline = '<!-- %s -->' },
                svelte = { __default = '<!-- %s -->', __multiline = '<!-- %s -->' },
                vue = { __default = '<!-- %s -->', __multiline = '<!-- %s -->' },
                astro = { __default = '<!-- %s -->', __multiline = '<!-- %s -->' },
                graphql = { __default = '# %s', __multiline = '""" %s """' },
            }
        })

        comment.setup({
            -- Enable line and block comment toggling
            toggler = {
                line = 'gcc',
                block = 'gbc',
            },
            -- Enable operator-pending mappings
            opleader = {
                line = 'gc',
                block = 'gb',
            },
            -- Enable extra mappings
            extra = {
                above = 'gcO',
                below = 'gco',
                eol = 'gcA',
            },
            -- Keybindings
            mappings = {
                basic = true,
                extra = true,
            },
            -- Enable sticky comments (maintains indentation)
            sticky = true,
            -- Ignore empty lines
            ignore = '^$',
            -- Enable padding for line comments
            padding = true,
            -- Enable word-wise toggling
            toggler_wordwise = true,
            -- Pre-hook for context-aware commenting
            pre_hook = function(ctx)
                -- Get location for commentstring
                local U = require('Comment.utils')
                
                -- Handle file types with mixed syntax
                local location = nil
                if ctx.ctype == U.ctype.linewise then
                    location = require('ts_context_commentstring.utils').get_cursor_location()
                elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                    location = require('ts_context_commentstring.utils').get_visual_start_location()
                end

                return require('ts_context_commentstring.internal').calculate_commentstring({
                    key = ctx.ctype == U.ctype.linewise and '__default' or '__multiline',
                    location = location,
                })
            end,
            -- Post-hook for custom operations
            post_hook = function(ctx)
                -- Auto-format commented region if formatexpr is set
                if vim.bo.formatexpr ~= '' then
                    local start_line = ctx.range.srow
                    local end_line = ctx.range.erow
                    vim.cmd(string.format('%d,%dformat', start_line, end_line))
                end
            end,
        })
        
        -- Extended mappings for comment operations
        local api = require('Comment.api')
        vim.keymap.set('n', '<leader>/', api.toggle.linewise.current, { desc = "Toggle line comment" })
        vim.keymap.set('n', '<leader>?', api.toggle.blockwise.current, { desc = "Toggle block comment" })
        
        -- Visual mode mappings
        vim.keymap.set('x', '<leader>/', function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
            api.toggle.linewise(vim.fn.visualmode())
        end, { desc = "Toggle comment for selection" })
        
        -- Add specialized comment mappings
        vim.keymap.set('n', '<leader>co', api.insert.linewise.above, { desc = "Add comment above" })
        vim.keymap.set('n', '<leader>cO', api.insert.linewise.below, { desc = "Add comment below" })
        vim.keymap.set('n', '<leader>cA', api.insert.linewise.eol, { desc = "Add comment at end of line" })
        
        -- Enhanced language support
        local ft = require('Comment.ft')

        -- Enhanced keymaps
        local api = require('Comment.api')

        vim.api.nvim_create_user_command('CommentToggle', function(opts)
            local count = opts.count
            local mode = opts.args
            if mode == 'line' then
                api.toggle.linewise.current()
            elseif mode == 'block' then
                api.toggle.blockwise.current()
            end
        end, {
            nargs = '?',
            count = true,
            complete = function()
                return { 'line', 'block' }
            end,
            desc = 'Toggle comments'
        })

        -- Set up comment string overrides for specific filetypes
        local ft = require('Comment.ft')
        ft.set('yaml', '#%s')
        ft.set('dockerfile', '#%s')
        ft.set('terraform', '#%s')
        ft.set('prisma', '//%s')
    end,
}