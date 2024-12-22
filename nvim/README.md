# Neovim Configuration

A comprehensive Neovim configuration with support for multiple languages and modern IDE features.

> Leader key is set to `\`

## Table of Contents

- [Core Navigation & Basic Operations](#core-navigation--basic-operations)
- [LSP Features](#lsp-features)
- [File Navigation & Search](#file-navigation--search)
- [Git Integration](#git-integration)
- [Terminal Integration](#terminal-integration)
- [Language Specific Features](#language-specific-features)
- [Debug Controls](#debug-controls)
- [AI Assistant Integration](#ai-assistant-integration)
- [Code Formatting & Comments](#code-formatting--comments)
- [Database Operations](#database-operations)
- [Text Manipulation](#text-manipulation)

## Core Navigation & Basic Operations

### Clipboard Operations
- `<leader>y` - Yank to system clipboard (normal and visual mode)
- `gV` - Select last inserted text

### Buffer Navigation (barbar.nvim)
- `<A-,>` - Previous buffer
- `<A-.>` - Next buffer
- `<A-<>` - Move buffer left
- `<A->>` - Move buffer right
- `<A-1-9>` - Go to buffer 1-9
- `<A-0>` - Go to last buffer
- `<A-c>` - Close buffer
- `<leader>bp` - Pin/unpin buffer
- `<leader>bc` - Close buffer
- `<leader>bx` - Close buffer
- `<leader>bX` - Close all but current/pinned
- `<leader>bL` - Close all to the left
- `<leader>bR` - Close all to the right
- `<leader>bb` - Order by buffer number
- `<leader>bd` - Order by directory
- `<leader>bl` - Order by language
- `<leader>bw` - Order by window number

### Config Reload
- `<leader>r` - Reload configuration

## LSP Features

### Code Navigation
- `K` - Hover Documentation
- `gd` - Go to Definition
- `gD` - Go to Declaration
- `gi` - Go to Implementation
- `gr` - Find References
- `<leader>rn` - Rename Symbol
- `<leader>ca` - Code Actions
- `<leader>D` - Type Definition
- `<leader>ds` - Document Symbols
- `<leader>ws` - Workspace Symbols

### Diagnostics
- `[d` - Previous Diagnostic
- `]d` - Next Diagnostic
- `<leader>e` - Float Diagnostic
- `<leader>q` - Set Diagnostic to Location List

### Code Completion
- `<C-Space>` - Complete
- `<C-b>` - Scroll docs up
- `<C-f>` - Scroll docs down
- `<Tab>` - Next item
- `<S-Tab>` - Previous item
- `<CR>` - Confirm selection

## File Navigation & Search

### File Explorer (NvimTree)
- `<leader>E` - Toggle file explorer
- `<leader>F` - Focus file explorer

### Telescope
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - File browser
- `<leader>fr` - Recent files (Frecency)
- `<leader>fh` - Help tags
- `<leader>bb` - List buffers

#### Git Integration with Telescope
- `<leader>gf` - Git files
- `<leader>gc` - Git commits
- `<leader>gb` - Git branches
- `<leader>gs` - Git status
- `<leader>gL` - Git branch diff
- `<leader>gl` - Git commit diff

### Quick File Access (Harpoon)
- `<leader>ha` - Add file to harpoon
- `<leader>he` - Show harpoon menu
- `<C-h>` - Navigate to harpoon 1
- `<C-j>` - Navigate to harpoon 2
- `<C-k>` - Navigate to harpoon 3
- `<C-l>` - Navigate to harpoon 4

### Quick Movement (Leap)
- `s` - Leap forward to
- `S` - Leap backward to

## Git Integration (Gitsigns)

### Navigation
- `]c` - Next hunk
- `[c` - Previous hunk

### Actions
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>tb` - Toggle current line blame
- `<leader>hd` - Diff this
- `<leader>hD` - Diff against ~
- `<leader>td` - Toggle deleted

### Text Objects
- `ih` - Select hunk

## Terminal Integration (Toggleterm)

### Terminal Controls
- `<C-\>` - Toggle terminal
- `<leader>tt` - Toggle terminal
- `<leader>tg` - Toggle lazygit
- `<leader>tn` - Toggle node REPL
- `<leader>tp` - Toggle python REPL

### Terminal Navigation
- `<esc>` - Exit terminal mode
- `jk` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate between windows in terminal

## Language Specific Features

### TypeScript/JavaScript
- `<leader>tsi` - Organize imports
- `<leader>tsa` - Add missing imports
- `<leader>tsf` - Fix all
- `<leader>tsr` - Rename file
- `<leader>tsd` - Go to source definition

### Python
- `<leader>pt` - Run current Python file
- `<leader>dpr` - Debug Python test method
- `<leader>dpc` - Debug Python test class
- `<leader>dps` - Debug Python selection
- `<leader>dpd` - Debug Django runserver
- `<leader>dpf` - Debug Flask run

### Go
- `<leader>gs` - Add tags
- `<leader>gr` - Remove tags
- `<leader>gd` - Go to definition
- `<leader>gt` - Go to declaration
- `<leader>gi` - Implement interface
- `<leader>ge` - Add if err check
- `<leader>gc` - Comment
- `<leader>gT` - Generate function tests
- `<leader>gsj` - Add json tags
- `<leader>gsy` - Add yaml tags
- `<leader>gt` - Run tests
- `<leader>gtf` - Test function
- `<leader>gT` - Test file
- `<leader>gfi` - Fill struct
- `<leader>gat` - Generate test for function
- `<leader>gal` - Code lens
- `<leader>glt` - Lint

### Ruby/Rails
- `<leader>rs` - Run Rails spec
- `<leader>rm` - Rails model
- `<leader>rc` - Rails controller
- `<leader>rv` - Rails view
- `<leader>rr` - Rails routes
- `<leader>rl` - Rails logs
- `<leader>rg` - Rails generate
- `<leader>rmig` - Rails migrations

### C/C++
- `<leader>cc` - Compile and run C++ file
- `<leader>cd` - Compile and run C file

## Debug Controls (DAP)
- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dt` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dr` - Open REPL
- `<leader>dl` - Run last

## AI Assistant Integration (Supermaven)

### Suggestions
- `<Tab>` - Accept suggestion
- `<C-]>` - Next suggestion
- `<C-[>` - Previous suggestion
- `<C-\>` - Dismiss suggestion
- `<C-p>` - Next suggestion
- `<C-o>` - Previous suggestion
- `<C-u>` - Dismiss suggestion

### Panel Controls
- `<leader>sm` - Start Supermaven
- `<leader>sd` - Stop Supermaven
- `<leader>se` - Toggle Supermaven

## Code Formatting & Comments

### Comments (Comment.nvim)
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` - Toggle line comment (with motion)
- `gb` - Toggle block comment (with motion)
- `gcO` - Comment above
- `gco` - Comment below
- `gcA` - Comment at end of line
- `<leader>/` - Toggle comment line/selection

### Formatting
- `<leader>mp` - Format file or range (in visual mode)

### Linting
- `<leader>l` - Trigger linting for current file

### Treesitter Context
- `[c` - Go to context
- `<leader>tc` - Toggle treesitter context

## Database Operations (vim-dadbod)
- `<leader>db` - Toggle DBUI
- `<leader>db+` - Add DB Connection
- `<leader>dbr` - DBUI Refresh
- `<leader>dbf` - DBUI Find Buffer
- `<leader>dbl` - DBUI Last Buffer

## Text Manipulation

### Surround Operations (nvim-surround)
- `ys{motion}{char}` - Add surround
- `yss{char}` - Add surround to line
- `ds{char}` - Delete surround
- `cs{target}{replacement}` - Change surround
- Visual Mode:
  - `S{char}` - Surround selection
- Insert Mode:
  - `<C-g>s` - Add surround
  - `<C-g>S` - Add surround on new lines
