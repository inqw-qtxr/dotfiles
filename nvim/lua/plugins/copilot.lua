return {
    "github/copilot.vim",
    config = function()
      -- Disable Copilot's default <Tab> behavior
      vim.g.copilot_no_tab_map = true
  
      vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { 
        noremap = true, 
        silent = true, 
        expr = true 
      })
    end
  } 