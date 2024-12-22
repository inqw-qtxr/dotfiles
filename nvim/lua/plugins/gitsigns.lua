return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '│' },
            change       = { text = '│' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        -- Core settings
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },
        attach_to_untracked = true,
        
        -- Blame settings
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol',
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        
        -- Performance settings
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        
        -- Preview window settings
        preview_config = {
            border = 'rounded',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1,
        },
        
        -- Custom signs and highlights
        count_chars = {
            [1] = '1',
            [2] = '2',
            [3] = '3',
            [4] = '4',
            [5] = '5',
            [6] = '6',
            [7] = '7',
            [8] = '8',
            [9] = '9',
            ['+'] = '>'
        },
        
        -- Hook for status line integration
        status_formatter = function(status)
            local added, changed, removed = status.added, status.changed, status.removed
            local status_txt = {}
            if added and added > 0 then table.insert(status_txt, '+' .. added) end
            if changed and changed > 0 then table.insert(status_txt, '~' .. changed) end
            if removed and removed > 0 then table.insert(status_txt, '-' .. removed) end
            return table.concat(status_txt, ' ')
        end,
    },
    config = function(_, opts)
        local gs = require("gitsigns")
        
        -- Setup with options
        gs.setup(vim.tbl_deep_extend("force", opts, {
            on_attach = function(bufnr)
                -- Helper function for mapping keys
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        desc = desc,
                        silent = true,
                    })
                end
                
                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, "Next hunk")
                
                map("n", "[c", function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, "Previous hunk")
                
                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>hs", function()
                    gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
                end, "Stage selected hunk")
                map("v", "<leader>hr", function()
                    gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
                end, "Reset selected hunk")
                map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function()
                    gs.blame_line { full = true }
                end, "Blame line")
                map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
                map("n", "<leader>hd", gs.diffthis, "Diff this")
                map("n", "<leader>hD", function()
                    gs.diffthis('~')
                end, "Diff against last commit")
                map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
                
                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
                
                -- Custom commands for common workflows
                vim.api.nvim_buf_create_user_command(bufnr, "GitSignsQuickfix", function()
                    gs.setqflist("all")
                end, { desc = "Put all hunks in quickfix" })
                
                vim.api.nvim_buf_create_user_command(bufnr, "GitSignsBlameToggle", function()
                    gs.toggle_current_line_blame()
                end, { desc = "Toggle current line blame" })
            end,
        }))
        
        -- Create highlight groups
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98c379" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e5c07b" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e06c75" })
    end,
}