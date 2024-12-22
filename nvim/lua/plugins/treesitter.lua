return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",    -- Shows code context
        "JoosepAlviste/nvim-ts-context-commentstring", -- Better comment string detection
        "windwp/nvim-ts-autotag",                     -- Auto close/rename HTML tags
        "RRethy/nvim-treesitter-endwise",            -- Adds end to Ruby/Lua functions
    },
    config = function()
        local configs = require("nvim-treesitter.configs")
        
        -- List of parsers to install
        local ensure_installed = {
            -- Languages
            "lua", "python", "typescript", "javascript", "go", "rust", "c", "cpp",
            "html", "css", "json", "yaml", "tsx", "java", "php",
            "scss", "jsdoc", "prisma", "graphql", "regex",
            -- Ruby
            "ruby", "embedded_template",
            -- Shell and tools
            "bash", "fish", "make", "dockerfile", "cmake",
            -- Documentation
            "markdown", "markdown_inline", "vimdoc",
            -- Git
            "git_rebase", "gitcommit", "gitignore", "gitattributes",
            -- Configuration
            "toml", "vim", "regex", "query", "ini",
            -- Web
            "xml", "vue", "svelte", "astro",
            -- Database
            "sql",
            -- DevOps
            "terraform", "hcl",
        }

        configs.setup({
            ensure_installed = ensure_installed,
            sync_install = false,
            auto_install = true,
            ignore_install = {},

            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
                disable = { "yaml" },  -- YAML indentation can be problematic
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<C-s>",
                    node_decremental = "<bs>",
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- Functions
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        -- Classes
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        -- Conditionals
                        ["ai"] = "@conditional.outer",
                        ["ii"] = "@conditional.inner",
                        -- Loops
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        -- Comments
                        ["aC"] = "@comment.outer",
                        -- Blocks
                        ["ab"] = "@block.outer",
                        ["ib"] = "@block.inner",
                        -- Parameters
                        ["ap"] = "@parameter.outer",
                        ["ip"] = "@parameter.inner",
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                },

                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]p"] = "@parameter.inner",
                        ["]b"] = "@block.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[p"] = "@parameter.inner",
                        ["[b"] = "@block.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },

                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>sn"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>sp"] = "@parameter.inner",
                    },
                },

                lsp_interop = {
                    enable = true,
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer",
                    },
                },
            },

            autotag = {
                enable = true,
                filetypes = {
                    "html", "xml", "javascript", "typescript", "javascriptreact", 
                    "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript",
                    "php", "markdown", "astro", "glimmer", "handlebars", "hbs",
                },
            },

            endwise = {
                enable = true,
            },

            -- Experimental features
            playground = {
                enable = true,
                disable = {},
                updatetime = 25,
                persist_queries = false,
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        })

        -- Setup treesitter context
        require('treesitter-context').setup({
            enable = true,
            max_lines = 3,
            trim_scope = 'outer',
            patterns = {
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

        -- Commands for manual folds
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false  -- Disable folding by default
    end,
}