return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        -- Copilot base configuration
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_filetypes = {
            ["*"] = true,
            -- Disable for specific filetypes
            ["markdown"] = false,
            ["help"] = false,
            ["gitcommit"] = false,
            ["gitrebase"] = false,
            ["hgcommit"] = false,
            ["svn"] = false,
            ["cvs"] = false,
        }

        -- Suggestion display settings
        vim.g.copilot_suggestion_delay = 100 -- ms before suggestions appear
        vim.g.copilot_suggestion_edge_lines = 50 -- lines from top/bottom to check for context

        -- Custom keymaps for Copilot
        local function create_copilot_commands()
            -- Create command to toggle Copilot
            vim.api.nvim_create_user_command("CopilotToggle", function()
                if vim.g.copilot_enabled == 0 then
                    vim.cmd("Copilot enable")
                    vim.notify("Copilot enabled", vim.log.levels.INFO)
                else
                    vim.cmd("Copilot disable")
                    vim.notify("Copilot disabled", vim.log.levels.INFO)
                end
            end, { desc = "Toggle Copilot" })
        end

        -- Keymaps
        local opts = { silent = true, expr = true }

        -- Accept suggestion
        vim.keymap.set("i", "<Tab>", 'copilot#Accept("<CR>")', opts)
        
        -- Navigate suggestions
        vim.keymap.set("i", "<M-]>", 'copilot#Next()', 
            vim.tbl_extend("force", opts, { desc = "Next suggestion" }))
        vim.keymap.set("i", "<M-[>", 'copilot#Previous()', 
            vim.tbl_extend("force", opts, { desc = "Previous suggestion" }))
        
        -- Dismiss current suggestion
        vim.keymap.set("i", "<M-\\>", 'copilot#Dismiss()', 
            vim.tbl_extend("force", opts, { desc = "Dismiss suggestion" }))
        
        -- Suggest completion
        vim.keymap.set("i", "<M-CR>", 'copilot#Suggest()', 
            vim.tbl_extend("force", opts, { desc = "Trigger suggestion" }))

        -- Normal mode mappings for Copilot commands
        vim.keymap.set("n", "<leader>ct", "<cmd>CopilotToggle<CR>", 
            { desc = "Toggle Copilot" })
        vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<CR>", 
            { desc = "Open Copilot panel" })

        -- Create custom commands
        create_copilot_commands()

        -- Set up autocommands for Copilot
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                -- Enable completion only for specific file sizes
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
                if ok and stats and stats.size > max_filesize then
                    vim.b.copilot_enabled = false
                    vim.notify("Copilot disabled for large file", vim.log.levels.INFO)
                end
            end,
        })

        -- Status line integration
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Add Copilot status to statusline if available
                if vim.fn.exists("*copilot#Enabled") == 1 then
                    vim.opt.statusline:append("%{get(b:,'copilot_enabled',0)?'󰚩 ':''}") 
                end
            end,
        })
    end,
}