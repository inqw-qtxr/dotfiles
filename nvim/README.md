## ⌨️ Keybindings

> Leader key is set to `\`

### General

#### Window Navigation

- `<C-h>` - Move to left split
- `<C-j>` - Move to split below
- `<C-k>` - Move to split above
- `<C-l>` - Move to right split

#### Editor Controls

- `<leader>w` - Save file
- `<leader>q` - Quit
- `gV` - Select last inserted text
- `<leader>y` - Yank to system clipboard
- `<leader>yy` - Yank entire file to clipboard

#### Buffer Navigation

- `<A-,>` - Previous buffer
- `<A-.>` - Next buffer
- `<A-<>` - Move buffer left
- `<A->>` - Move buffer right
- `<A-1-9>` - Go to buffer 1-9
- `<A-0>` - Go to last buffer
- `<A-c>` - Close buffer
- `<A-p>` - Pick buffer
- `<leader>bx` - Close buffer
- `<leader>bX` - Close all but current/pinned
- `<leader>bL` - Close all to the left
- `<leader>bR` - Close all to the right
- `<leader>ba` - Close all but pinned
- `<leader>bp` - Pin/unpin buffer
- `<leader>bb` - List buffers

### LSP & Code Navigation

#### Code Navigation

- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<C-k>` - Signature help
- `<leader>D` - Type definition
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>cf` - Format document

#### Workspace Management

- `<leader>wa` - Add workspace folder
- `<leader>wr` - Remove workspace folder
- `<leader>wl` - List workspace folders

#### Diagnostics

- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>e` - Show diagnostic in float
- `<leader>q` - Send diagnostics to quickfix
- `<leader>xx` - Toggle trouble (diagnostic list)

### File Navigation

#### Telescope

- `<leader>ff` - Find files
- `<leader>fg` - Live grep with args
- `<leader>fb` - File browser
- `<leader>fr` - Recent files (frecency)
- `<leader>fh` - Help tags
- `<leader>fo` - Old files
- `<leader>fw` - Find word under cursor
- `<leader>fp` - Browse projects
- `<leader>bb` - List buffers
- `<leader>sd` - Search diagnostics
- `<leader>sk` - Search keymaps

#### NvimTree

- `<leader>E` - Toggle file explorer
- `<leader>F` - Focus file explorer
- `<leader>ef` - Find current file in tree
- `<leader>ec` - Collapse file explorer
- `<leader>er` - Refresh file explorer

#### Harpoon

- `<leader>ha` - Add file to harpoon
- `<leader>he` - Show harpoon menu
- `<leader>hc` - Clear all harpoon marks
- `<C-h>` - Navigate to file 1
- `<C-j>` - Navigate to file 2
- `<C-k>` - Navigate to file 3
- `<C-l>` - Navigate to file 4
- `[h` - Navigate to previous mark
- `]h` - Navigate to next mark
- `<leader>hf` - Find harpoon marks

### Git Integration

#### Git Commands (Telescope)

- `<leader>gf` - Git files
- `<leader>gc` - Git commits
- `<leader>gb` - Git branches
- `<leader>gs` - Git status
- `<leader>gL` - Git branch diff
- `<leader>gl` - Git commit diff

#### Gitsigns

- `]c` - Next hunk
- `[c` - Previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>tb` - Toggle line blame
- `<leader>hd` - Diff this
- `<leader>hD` - Diff against last commit
- `<leader>td` - Toggle deleted

### Terminal Integration

- `<C-\>` - Toggle terminal (global)
- `<leader>tt` - Toggle terminal
- `<leader>tg` - Toggle lazygit
- `<leader>tn` - Toggle node REPL
- `<leader>tp` - Toggle python REPL
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal
- `<leader>tf` - Toggle float terminal

### Language Specific

#### TypeScript/JavaScript

- `<leader>tsi` - Organize imports
- `<leader>tsa` - Add missing imports
- `<leader>tsf` - Fix all
- `<leader>tsr` - Rename file
- `<leader>tsd` - Go to source definition
- `<leader>tst` - Go to definition in split
- `<leader>tsR` - Rename symbol
- `<leader>tsu` - Remove unused
- `<leader>tss` - Show references

#### Go

- `<leader>gsj` - Add json tags
- `<leader>gsy` - Add yaml tags
- `<leader>gfi` - Fill struct
- `<leader>gie` - Add if err
- `<leader>gim` - Implement interface
- `<leader>gc` - Generate comment
- `<leader>gt` - Run tests
- `<leader>gtf` - Test function
- `<leader>gT` - Test file
- `<leader>gat` - Generate test for function
- `<leader>gr` - Run package
- `<leader>gb` - Build package
- `<leader>gal` - Code lens
- `<leader>glt` - Lint
- `<leader>gcl` - Clear coverage
- `<leader>gcv` - Toggle coverage
- `<leader>gdb` - Start debugger
- `<leader>gdt` - Debug test
- `<leader>gds` - Stop debugger

### Debugging

- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dt` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dr` - Open REPL
- `<leader>dl` - Run last
- `<leader>dh` - Hover variables
- `<leader>dp` - Pause
- `<leader>df` - Focus frame
- `<leader>ds` - Stop debugging

### Code Formatting & Comments

- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `<leader>/` - Toggle line comment
- `<leader>?` - Toggle block comment
- `<leader>co` - Add comment above
- `<leader>cO` - Add comment below
- `<leader>cA` - Add comment at end of line
- `<leader>mp` - Format file or range
- `<leader>mw` - Format and write file

### Movement and Text Objects

#### Leap Navigation

- `s` - Leap forward
- `S` - Leap backward
- `gs` - Leap from windows
- `x` - Leap cross-window (operator mode)

#### Surround Operations

- `ys{motion}` - Add surround
- `yss` - Add surround to line
- `yS` - Add surround and indent
- `ds` - Delete surround
- `cs` - Change surround
- Text objects: `ih` (select hunk)

#### Treesitter Objects

- `af`/`if` - Around/inner function
- `ac`/`ic` - Around/inner class
- `ai`/`ii` - Around/inner conditional
- `al`/`il` - Around/inner loop
- `aC` - Around comment
- `ab`/`ib` - Around/inner block
- `ap`/`ip` - Around/inner parameter

### Markdown Preview

- `<leader>mp` - Toggle markdown preview
- `<leader>ms` - Stop markdown preview
