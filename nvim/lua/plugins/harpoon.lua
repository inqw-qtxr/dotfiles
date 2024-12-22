return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",  -- Use the newer version
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    keys = {
        -- Mark operations
        {
            "<leader>ha",
            function()
                require("harpoon"):list():append()
            end,
            desc = "Add file to harpoon"
        },
        {
            "<leader>he",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Show harpoon menu"
        },
        {
            "<leader>hc",
            function()
                require("harpoon"):list():clear()
            end,
            desc = "Clear all harpoon marks"
        },
        -- Navigation
        {
            "<C-h>",
            function()
                require("harpoon"):list():select(1)
            end,
            desc = "Navigate to harpoon 1"
        },
        {
            "<C-j>",
            function()
                require("harpoon"):list():select(2)
            end,
            desc = "Navigate to harpoon 2"
        },
        {
            "<C-k>",
            function()
                require("harpoon"):list():select(3)
            end,
            desc = "Navigate to harpoon 3"
        },
        {
            "<C-l>",
            function()
                require("harpoon"):list():select(4)
            end,
            desc = "Navigate to harpoon 4"
        },
        -- Additional navigation
        {
            "[h",
            function()
                require("harpoon"):list():prev()
            end,
            desc = "Navigate to previous mark"
        },
        {
            "]h",
            function()
                require("harpoon"):list():next()
            end,
            desc = "Navigate to next mark"
        },
    },
    opts = {
        settings = {
            save_on_toggle = true,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon", "neo-tree", "dashboard" },
            mark_branch = true,  -- Mark files per git branch
            tabline = false,     -- Enable tabline integration
            tabline_prefix = "   ",
            tabline_suffix = "   ",
            menu = {
                width = 60,
                height = 10,
                border = "rounded",
            },
        },
        -- Default view options
        default_list = {
            encode = "json", -- Other options: "base64", "messagepack"
            limit = 10,      -- Maximum number of items in list
        },
    },
    config = function(_, opts)
        local harpoon = require("harpoon")
        
        -- Basic setup
        harpoon:setup(opts)
        
        -- Setup marks display in statusline
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
                vim.schedule(function()
                    local mark_idx = harpoon:list():get_index()
                    if mark_idx then
                        vim.b.harpoon_mark = "⥤ " .. mark_idx
                    else
                        vim.b.harpoon_mark = ""
                    end
                end)
            end,
        })

        -- Optional: Telescope integration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>hf", function()
            toggle_telescope(harpoon:list())
        end, { desc = "Find harpoon marks" })

        -- Custom commands
        vim.api.nvim_create_user_command("HarpoonAdd", function()
            harpoon:list():append()
        end, { desc = "Add current file to harpoon" })

        vim.api.nvim_create_user_command("HarpoonRemove", function()
            harpoon:list():remove()
        end, { desc = "Remove current file from harpoon" })

        vim.api.nvim_create_user_command("HarpoonClear", function()
            harpoon:list():clear()
        end, { desc = "Clear all harpoon marks" })
    end,
}