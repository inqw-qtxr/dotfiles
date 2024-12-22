return {
    "windwp/nvim-autopairs",
    event = { "InsertEnter", "CmdlineEnter" }, -- Add CmdlineEnter for command line completion
    dependencies = {
        "hrsh7th/nvim-cmp", -- Optional: Only if you use nvim-cmp
    },
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        npairs.setup({
            check_ts = true,
            ts_config = {
                lua = { "string", "source" },           -- Added 'source' for better Lua detection
                javascript = { "template_string", "string" },
                typescript = { "template_string", "string" },
                java = false,
            },

            disable_filetype = {
                "TelescopePrompt",
                "vim",
                "spectre_panel",
                "dirvish",
                "fugitive",
                "alpha",  -- For startup screen
            },

            -- More specific next char pattern
            ignored_next_char = "[%w%.%(%{%[%'%\"]",

            -- Enhanced fast wrap
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'", "`" }, -- Added backtick
                pattern = [=[[%'%"%>%]%)%}%,%;%`]]=],     -- Added semicolon and backtick
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                manual_position = true,
                highlight = "PmenuSel",                   -- Changed highlight group
                highlight_grey = "LineNr",                -- Changed highlight group
                offset = 0,                               -- Added offset for more precise positioning
            },

            enable_check_bracket_line = true,
            check_ts = true,
            disable_in_macro = true,                      -- Changed to true for better macro handling
            disable_in_visualblock = true,                -- Changed to true for better visual block handling
            disable_in_replace_mode = true,
            enable_moveright = true,
            enable_afterquote = true,
            enable_bracket_in_quote = true,
            
            -- Added break line rules
            break_undo = true,                           -- Should break undo sequence on deletion
            map_cr = true,                               -- Map <CR> key
            map_bs = true,                               -- Map <BS> key
        })

        -- Enhanced space rules
        npairs.add_rules({
            Rule(" ", " ")
                :with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ "()", "[]", "{}", "<>" }, pair)  -- Added <> pairs
                end)
                :with_move(cond.none())
                :with_cr(cond.none())
                :with_del(function(opts)
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local context = opts.line:sub(col - 1, col + 2)
                    return vim.tbl_contains({ "(  )", "[  ]", "{  }", "<  >" }, context)
                end),
            
            -- Space rules for closing brackets
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
                :use_key("}"),
            Rule("", " >")
                :with_pair(cond.none())
                :with_move(function(opts) return opts.char == ">" end)
                :with_cr(cond.none())
                :with_del(cond.none())
                :use_key(">"),
        })

        -- Enhanced markdown rules
        npairs.add_rules({
            Rule("`", "`", { "markdown", "vimwiki", "mdx", "text" })
                :with_pair(cond.not_before_text(" "))
                :with_pair(cond.not_after_text(" "))
                :with_pair(cond.not_after_regex("^%s*$")), 

            -- Improved triple backticks rule
            Rule("```", "```", { "markdown", "vimwiki", "mdx" })
                :with_pair(function(opts)
                    local line = opts.line
                    local col = opts.col
                    return col == 3 and line:sub(1, col) == "```" 
                        and not line:match("^```%s*[%w_-]+%s*$")
                end)
                :with_cr(function(opts)
                    return true
                end),

            -- HTML/JSX/TSX tag rule
            Rule("<", ">", { "html", "typescript", "javascript", "javascriptreact", "typescriptreact" })
                :with_pair(cond.not_before_regex("%w"))
                :with_move(function(opts) return opts.char == ">" end)
        })

        -- nvim-cmp integration with better error handling
        local ok, cmp = pcall(require, "cmp")
        if ok then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local handlers = require("nvim-autopairs.completion.handlers")
            
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({
                filetypes = {
                    -- Disable for specific filetypes
                    ["*"] = {
                        ["("] = {
                            kind = {
                                cmp.lsp.CompletionItemKind.Function,
                                cmp.lsp.CompletionItemKind.Method,
                            },
                            handler = handlers["*"]
                        }
                    },
                    -- Disable for specific filetypes
                    tex = false,
                    plaintex = false,
                }
            }))
        end
    end,
}