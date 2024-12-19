return {
    "vim-test/vim-test",
    config = function()
        -- Add keymaps before configuration
        vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { noremap = true, desc = "Run last test" })
        vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { noremap = true, desc = "Visit test file" })
        vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", { noremap = true, desc = "Run test suite" })
        vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { noremap = true, desc = "Run nearest test" })
    
        -- Configure vim-test
        vim.g["test#strategy"] = "neovim"     -- Run tests in a split window
        vim.g["test#neovim#term_position"] = "botright"
        vim.g["test#preserve_screen"] = 1
    
        -- Configure test runners
        vim.g["test#ruby#runner"] = "rspec"         -- Use RSpec for Ruby
        vim.g["test#javascript#runner"] = "jest"     -- Use Jest for JavaScript/TypeScript
        vim.g["test#python#runner"] = "pytest"       -- Use pytest for Python
        vim.g["test#go#runner"] = "gotest"          -- Use go test for Go
    
        -- Strategy configuration
        vim.g["test#neovim#start_normal"] = 1       -- Start in normal mode
        vim.g["test#basic#start_normal"] = 1        -- Start in normal mode
    
        -- Additional settings
        vim.g["test#echo_command"] = 1              -- Echo the command being run
        vim.g["test#neovim#term_position"] = "vert" -- Open the test window vertically
    
        -- Set up custom test transformations
        vim.g["test#project_root"] = vim.fn.getcwd()
    
        -- Enable colors in test output
        vim.g["test#preserve_screen"] = 1
    
        -- Configure test file patterns
        vim.g["test#filename_modifier"] = ":p"       -- Use absolute paths
        vim.g["test#python#pytest#options"] = {
        all = "--verbose"
        }
        vim.g["test#javascript#jest#options"] = {
        all = "--verbose",
        nearest = "--verbose"
        }
        vim.g["test#ruby#rspec#options"] = {
        all = "--format documentation"
        }
    
        -- Optional: Integration with Terminal
        vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*",
        callback = function()
            if vim.v.event.status == 0 then
                vim.cmd("wincmd p") -- Return to the previous window on success
            end
        end,
        })
        end,
}