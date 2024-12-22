return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>tt", desc = "Toggle terminal" },
        { "<leader>tg", desc = "Toggle lazygit" },
        { "<leader>tn", desc = "Toggle node REPL" },
        { "<leader>tp", desc = "Toggle python REPL" },
        { "<leader>th", desc = "Toggle horizontal terminal" },
        { "<leader>tv", desc = "Toggle vertical terminal" },
        { "<leader>tf", desc = "Toggle float terminal" },
        { "<C-\\>", desc = "Toggle terminal (global)" },
    },
    config = function()
        local toggleterm = require("toggleterm")
        local Terminal = require("toggleterm.terminal").Terminal

        -- Global config
        toggleterm.setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return math.floor(vim.o.lines * 0.3)  -- 30% of screen height
                elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)  -- 40% of screen width
                end
            end,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            auto_scroll = true,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
                width = function()
                    return math.floor(vim.o.columns * 0.8)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
            },
            winbar = {
                enabled = true,
                name_formatter = function(term)
                    return term.name or term.cmd
                end,
            },
        })

        -- Terminal Definitions
        local terminals = {
            lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            }),
            node = Terminal:new({
                cmd = "node",
                hidden = true,
                direction = "float",
                on_open = function(term)
                    vim.cmd("startinsert!")
                end,
            }),
            python = Terminal:new({
                cmd = "python",
                hidden = true,
                direction = "float",
                on_open = function(term)
                    vim.cmd("startinsert!")
                end,
            }),
            horizontal = Terminal:new({
                direction = "horizontal",
                hidden = true,
            }),
            vertical = Terminal:new({
                direction = "vertical",
                hidden = true,
            }),
            float = Terminal:new({
                direction = "float",
                hidden = true,
            }),
        }

        -- Terminal toggle functions
        local function create_toggle_function(term)
            return function()
                term:toggle()
            end
        end

        -- Terminal toggle functions with count support
        local function create_numbered_toggle_function(direction)
            return function()
                local count = vim.v.count
                if count == 0 then
                    terminals[direction]:toggle()
                else
                    toggleterm.toggle(count, direction)
                end
            end
        end

        -- Keymaps
        local function map(mode, lhs, rhs, opts)
            local options = { noremap = true, silent = true }
            if opts then
                options = vim.tbl_extend("force", options, opts)
            end
            vim.keymap.set(mode, lhs, rhs, options)
        end

        -- Main terminal toggles
        map("n", "<leader>tt", create_toggle_function(terminals.float), { desc = "Toggle terminal" })
        map("n", "<leader>th", create_numbered_toggle_function("horizontal"), { desc = "Toggle horizontal terminal" })
        map("n", "<leader>tv", create_numbered_toggle_function("vertical"), { desc = "Toggle vertical terminal" })
        map("n", "<leader>tf", create_toggle_function(terminals.float), { desc = "Toggle float terminal" })

        -- Application-specific terminals
        map("n", "<leader>tg", create_toggle_function(terminals.lazygit), { desc = "Toggle lazygit" })
        map("n", "<leader>tn", create_toggle_function(terminals.node), { desc = "Toggle node REPL" })
        map("n", "<leader>tp", create_toggle_function(terminals.python), { desc = "Toggle python REPL" })

        -- Terminal navigation
        local function set_terminal_keymaps()
            local opts = { buffer = true, noremap = true, silent = true }
            -- Exit terminal mode
            map("t", "<esc>", [[<C-\><C-n>]], opts)
            map("t", "jk", [[<C-\><C-n>]], opts)
            
            -- Window navigation
            map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
            map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
            map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
            map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            
            -- Terminal specific
            map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)  -- Window commands
            map("t", "<C-d>", [[<C-d>]], opts)            -- Scroll down
            map("t", "<C-u>", [[<C-u>]], opts)            -- Scroll up
        end

        -- Auto-commands
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
                set_terminal_keymaps()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.signcolumn = "no"
                vim.cmd("startinsert!")
            end,
        })
    end,
}