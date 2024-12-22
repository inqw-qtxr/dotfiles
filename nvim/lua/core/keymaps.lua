-- Set the leader key to backslash
vim.g.mapleader = "\\"

-- Go Keymaps
vim.keymap.set("n", "<leader>gs", ":GoAddTags<CR>", { noremap = true, desc = "Go: Add tags" })
vim.keymap.set("n", "<leader>gr", ":GoRemoveTags<CR>", { noremap = true, desc = "Go: Remove tags" })
vim.keymap.set("n", "<leader>gd", ":GoDef<CR>", { noremap = true, desc = "Go: Go to definition" })
vim.keymap.set("n", "<leader>gt", ":GoDecls<CR>", { noremap = true, desc = "Go: Go to declaration" })
vim.keymap.set("n", "<leader>gi", ":GoImpl<CR>", { noremap = true, desc = "Go: Implement interface" })
vim.keymap.set("n", "<leader>ge", ":GoIfErr<CR>", { noremap = true, desc = "Go: Add if err check" })
vim.keymap.set("n", "<leader>gc", ":GoCmt<CR>", { noremap = true, desc = "Go: Comment" })
vim.keymap.set("n", "<leader>gT", ":GoTestsFunc<CR>", { noremap = true, desc = "Go: Generate function tests" })

-- TypeScript Keymaps
vim.keymap.set("n", "<leader>tsi", ":TSToolsOrganizeImports<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>tsa", ":TSToolsAddMissingImports<CR>", { desc = "Add Missing Imports" })
vim.keymap.set("n", "<leader>tsf", ":TSToolsFixAll<CR>", { desc = "Fix All" })
vim.keymap.set("n", "<leader>tsr", ":TSToolsRenameFile<CR>", { desc = "Rename File" })
vim.keymap.set("n", "<leader>tsd", ":TSToolsGoToSourceDefinition<CR>", { desc = "Go To Source Definition" })

-- Ruby/Rails Keymaps
vim.keymap.set("n", "<leader>Ra", ":Rails<CR>", { noremap = true, desc = "Rails actions" })
vim.keymap.set("n", "<leader>Rc", ":Rails controller<CR>", { noremap = true, desc = "Rails controllers" })
vim.keymap.set("n", "<leader>Rm", ":Rails model<CR>", { noremap = true, desc = "Rails models" })
vim.keymap.set("n", "<leader>Rv", ":Rails view<CR>", { noremap = true, desc = "Rails views" })
vim.keymap.set("n", "<leader>Rr", ":Rails routes<CR>", { noremap = true, desc = "Rails routes" })
vim.keymap.set("n", "<leader>Rl", ":Rails logs<CR>", { noremap = true, desc = "Rails logs" })
vim.keymap.set("n", "<leader>Rg", ":Rails generate<CR>", { noremap = true, desc = "Rails generator" })
vim.keymap.set("n", "<leader>Rd", ":Rails db<CR>", { noremap = true, desc = "Rails database" })

-- Language Compilation/Execution
vim.keymap.set("n", "<leader>pt", ":!python %<CR>", { noremap = true, desc = "Run current Python file" })
vim.keymap.set("n", "<leader>cc", ":!g++ % -o %< && ./%<<CR>", { noremap = true, desc = "Compile and run C++ file" })
vim.keymap.set("n", "<leader>cd", ":!gcc % -o %< && ./%<<CR>", { noremap = true, desc = "Compile and run C file" })

-- Quality of Life
vim.keymap.set("n", "gV", "`[v`]", { noremap = true, desc = "Select last inserted text" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { noremap = true, desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>sr", ":source $MYVIMRC<CR>", { noremap = true, desc = "Reload configuration" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, desc = "Quit" })
vim.keymap.set("n", "<leader>yy", ":%y+<CR>", { noremap = true, desc = "Yank entire file" })