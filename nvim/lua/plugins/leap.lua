return {
    "ggandor/leap.nvim",
    dependencies = {
        "tpope/vim-repeat",
        -- Optional but recommended for enhanced jumping
        "ggandor/flit.nvim",
    },
    keys = {
        -- Define keymaps in a structured way
        { 
            "s", 
            mode = { "n", "x", "o" }, 
            desc = "Leap forward to" 
        },
        { 
            "S", 
            mode = { "n", "x", "o" }, 
            desc = "Leap backward to" 
        },
        { 
            "gs", 
            mode = { "n", "x", "o" }, 
            desc = "Leap from windows" 
        },
        {
            "x",
            mode = { "o" },
            desc = "Leap cross-window"
        },
    },
    opts = {
        max_phase_one_targets = nil,
        highlight_unlabeled_phase_one_targets = true,
        max_highlighted_traversal_targets = 10,
        case_sensitive = false,
        -- Empty safe_labels means labels exclude these characters
        safe_labels = {},
        -- Characters for jump labels
        labels = {
            "s", "f", "n", 
            "j", "k", "l", "h", "o", "d", "w", "e", "m", "b",
            "u", "y", "v", "r", "g", "t", "c", "x", "z"
        },
        -- Special keys that can be used while jumping
        special_keys = {
            next_target = "<enter>",
            prev_target = "<tab>",
            next_group = "<space>",
            prev_group = "<tab>",
            multi_accept = "<enter>",
            multi_revert = "<backspace>",
        },
    },
    config = function(_, opts)
        local leap = require("leap")
        
        -- Setup leap with opts
        for k, v in pairs(opts) do
            leap.opts[k] = v
        end

        -- Add default mappings but allow for customization
        leap.add_default_mappings()
        
        -- Custom keymaps for enhanced navigation
        vim.keymap.set(
            {'n', 'x', 'o'}, 
            's', 
            '<Plug>(leap-forward-to)', 
            { desc = "Leap forward to" }
        )
        vim.keymap.set(
            {'n', 'x', 'o'}, 
            'S', 
            '<Plug>(leap-backward-to)', 
            { desc = "Leap backward to" }
        )
        
        -- Cross-window jumping
        vim.keymap.set(
            {'n', 'x', 'o'}, 
            'gs', 
            function()
                leap.leap({ target_windows = vim.tbl_filter(
                    function(win) return vim.api.nvim_win_get_config(win).focusable end,
                    vim.api.nvim_tabpage_list_wins(0)
                )})
            end,
            { desc = "Leap from windows" }
        )

        -- Configure highlight groups
        vim.api.nvim_set_hl(0, 'LeapMatch', { 
            fg = '#ffffff', 
            bold = true, 
            nocombine = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { 
            fg = '#ff007c', 
            bold = true, 
            nocombine = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelSecondary', { 
            fg = '#00dfff', 
            bold = true, 
            nocombine = true,
        })
        
        -- Add custom autocommands
        local group = vim.api.nvim_create_augroup("LeapConfig", { clear = true })
        
        -- Automatically enter leap mode when switching windows
        vim.api.nvim_create_autocmd("WinEnter", {
            group = group,
            callback = function()
                if vim.bo.buftype == "" then  -- Only for normal buffers
                    local key = vim.api.nvim_replace_termcodes("s", true, false, true)
                    vim.api.nvim_feedkeys(key, "n", false)
                end
            end,
            enabled = false  -- Disabled by default, enable if desired
        })

        -- Optional: Integration with flit.nvim if installed
        local has_flit, flit = pcall(require, "flit")
        if has_flit then
            flit.setup({
                keys = { f = 'f', F = 'F', t = 't', T = 'T' },
                labeled_modes = "nx",
                multiline = true,
                opts = {
                    safe_labels = opts.safe_labels,
                    labels = opts.labels,
                }
            })
        end
    end,
}