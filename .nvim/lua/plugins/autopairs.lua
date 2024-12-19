return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        npairs.setup({
            check_ts = true,                      -- Enable treesitter
            ts_config = {
                lua = { "string" },               -- Don't add pairs in lua string treesitter nodes
                javascript = { "template_string" }, -- Don't add pairs in javascript template_string
                java = false,                     -- Don't check treesitter on java
            },

            -- Disable autopairs for specific filetypes
            disable_filetype = {
                "TelescopePrompt",
                "vim"
            },

            -- Don't add pairs if the next char is alphanumeric
            ignored_next_char = "[%w%.]",

            -- Enable fast wrap feature
            fast_wrap = {
                map = "<M-e>", -- Alt+e in insert mode to fast wrap
                chars = { "{", "[", "(", '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                manual_position = true,
                highlight = "Search",
                highlight_grey = "Comment"
            },

            -- Enable check bracket in same line
            enable_check_bracket_line = true,

            -- Will not add pair on that line when cond is false
            disable_in_macro = false,
            disable_in_visualblock = false,
            disable_in_replace_mode = true,
            enable_moveright = true,
            enable_afterquote = true, -- Add bracket pairs after quote
            enable_bracket_in_quote = true,
        })

        -- Add spaces between parentheses
        npairs.add_rules({
            Rule(" ", " ")
                :with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                end)
                :with_move(cond.none())
                :with_cr(cond.none())
                :with_del(function(opts)
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local context = opts.line:sub(col - 1, col + 2)
                    return vim.tbl_contains({ "(  )", "[  ]", "{  }" }, context)
                end),
            Rule("", " )")
                :with_pair(cond.none())
                :with_move(function(opts) return opts.char == ")" end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key(")"),
            Rule("", " ]")
                :with_pair(cond.none())
                :with_move(function(opts) return opts.char == "]" end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key("]"),
            Rule("", " }")
                :with_pair(cond.none())
                :with_move(function(opts) return opts.char == "}" end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key("}")
        })

        -- Add rules for specific filetypes
        npairs.add_rules({
            -- Add custom rule for markdown to handle `code` blocks
            Rule("`", "`", { "markdown", "vimwiki" })
                :with_pair(cond.not_before_text(" "))
                :with_pair(cond.not_after_text(" ")),

            -- Add custom rule for triple backticks in markdown
            Rule("```", "```", { "markdown", "vimwiki" })
                :with_pair(function(opts)
                    local line = opts.line
                    local col = opts.col
                    -- Only add the closing backticks if we're at the start of the line
                    return col == 3 and line:sub(1, col) == "```"
                end)
        })

        -- Optional: Integration with nvim-cmp if it's available
        local has_cmp, cmp = pcall(require, "cmp")
        if has_cmp then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end,
}