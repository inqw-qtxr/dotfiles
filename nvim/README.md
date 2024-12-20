# Neovim Configuration

A comprehensive Neovim configuration with support for multiple languages and modern IDE features.

> Leader key is set to `\`

## Table of Contents
- [Core Navigation & Basic Operations](#core-navigation--basic-operations)
- [Plugin Management](#plugin-management)
- [File Navigation & Search](#file-navigation--search)
- [Code Editing & Manipulation](#code-editing--manipulation)
- [LSP Features](#lsp-features)
- [Git Integration](#git-integration)
- [Testing](#testing)
- [Terminal Integration](#terminal-integration)
- [Language Specific Features](#language-specific-features)
- [Window Management](#window-management)
- [Code Navigation & Selection](#code-navigation--selection)
- [AI Assistant Integration](#ai-assistant-integration)

## Core Navigation & Basic Operations

### File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>x` - Save and quit
- `<leader>r` - Reload configuration

### Directory Operations
- `<leader>.` - Change directory to current file
- `<leader>cd` - Change directory to current file

### Clipboard Operations
- `<leader>y` - Yank to system clipboard
- `<leader>Y` - Yank line to system clipboard
- `<leader>yf` - Yank entire file to system clipboard
- `gV` - Select last inserted text

### Basic Navigation
- `<Esc>` - Exit any mode to normal mode
- `jk` - Alternative escape in terminal mode
- `<C-h/j/k/l>` - Navigate between windows

## Plugin Management

- `:Lazy` - Open lazy.nvim plugin manager
- `:LazyUpdate` - Update plugins
- `:LazySync` - Sync plugins
- `:LazyClean` - Clean unused plugins

## File Navigation & Search

### NvimTree (File Explorer)
- `<leader>E` - Toggle file explorer
- `<leader>F` - Focus file explorer

### Telescope
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in all files)
- `<leader>fb` - Browse buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files
- `<leader>fd` - File browser
- `<leader>fl` - Find in current buffer
- `<leader>fs` - Document symbols
- `<leader>fw` - Workspace symbols
- `<leader>fc` - Fuzzy find in current buffer
- `<leader>fm` - Browse marks
- `<leader>ft` - Browse Treesitter symbols
- `<leader>gf` - Git files
- `<leader>fW` - Find word under cursor

#### Telescope Navigation
- `<C-j/k>` - Move up/down in results
- `<C-n/p>` - Cycle through history
- `<C-c>` - Close telescope
- `<CR>` - Select item
- `<C-x>` - Split horizontal
- `<C-v>` - Split vertical
- `<C-d>` - Delete buffer (in buffer list)

## Code Editing & Manipulation

### Comment Operations
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` - Toggle line comment (with motion)
- `gb` - Toggle block comment (with motion)
- `<leader>/` - Toggle comment (normal and visual mode)
- `gcO` - Add comment above
- `gco` - Add comment below
- `gcA` - Add comment at end of line

### Surround Operations
- `ys{motion}{char}` - Add surround
- `ds{char}` - Delete surround
- `cs{target}{replacement}` - Change surround
- `yss{char}` - Surround entire line
- `ySS{char}` - Surround entire line on new lines
- Visual Mode: `S{char}` - Surround selection
- Insert Mode: `<C-g>s` - Add surrounding
- Insert Mode: `<C-g>S` - Add surrounding on new lines

### Auto-Pairs
- `<M-e>` - Fast wrap (Alt+e)
- Auto-closing of `()`, `[]`, `{}`, `""`, `''`, and ` `` `
- Auto-closing of Markdown code blocks

## LSP Features

### Code Navigation
- `gd` - Go to definition
- `K` - Show hover documentation
- `gi` - Go to implementation
- `gr` - Find references

### Code Actions
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>fF` - Format file

### Diagnostics
- `<leader>dd` - Show diagnostics
- `<leader>dn` - Next diagnostic
- `<leader>dp` - Previous diagnostic

### Workspace
- `<leader>wa` - Add workspace folder
- `<leader>wr` - Remove workspace folder
- `<leader>wl` - List workspace folders

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

### Selection
- `ih` - Select hunk (works in visual and operator mode)

## Testing (vim-test)

- `<leader>tl` - Run last test
- `<leader>tv` - Visit test file
- `<leader>ts` - Run test suite
- `<leader>tn` - Run nearest test

## Terminal Integration (Toggleterm)

### Terminal Operations
- `<C-\>` - Toggle floating terminal
- `<leader>tt` - Toggle terminal
- `<leader>tg` - Toggle lazygit
- `<leader>tn` - Toggle Node REPL
- `<leader>tp` - Toggle Python REPL

### Terminal Mode Navigation
- `<esc>` or `jk` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate between windows

## Language Specific Features

### Go
- `<leader>gfs` - Fill struct
- `<leader>gfp` - Fix plurals
- `<leader>gat` - Add tags to struct
- `<leader>grt` - Remove tags from struct
- `<leader>gct` - Clear tags from struct
- `<leader>gim` - Generate interface implementation
- `<leader>gte` - Run tests
- `<leader>gtf` - Test function
- `<leader>gtc` - Test coverage
- `<leader>ga` - Go to alternate file
- `<leader>gat` - Go to alternate file in vsplit
- `<leader>gd` - Go to definition
- `<leader>gdc` - Go to definition callback
- `<leader>gr` - Rename symbol
- `<leader>gi` - Show symbol info
- `<leader>gdb` - Start debugging
- `<leader>gdt` - Debug test
- `<leader>gdB` - Toggle breakpoint

### Ruby/Rails
- `<leader>ra` - Alternate file
- `<leader>rm` - Jump to model
- `<leader>rc` - Jump to controller
- `<leader>rv` - Jump to view
- `<leader>rh` - Jump to helper
- `<leader>rt` - Jump to test

### TypeScript/JavaScript
- `<leader>tsi` - Organize imports
- `<leader>tsa` - Add missing imports
- `<leader>tsf` - Fix all
- `<leader>tsr` - Rename file
- `<leader>tsd` - Go to source definition

### Markdown
- `<leader>mp` - Toggle Markdown Preview in browser

## Window Management
- `<leader>sh` - Split horizontally
- `<leader>se` - Make splits equal size

## Code Navigation & Selection

### Treesitter Selection
- `gnn` - Initialize selection
- `grn` - Increment selection by node
- `grc` - Increment selection by scope
- `grm` - Decrement selection

### Text Objects
- `af` - Around function
- `if` - Inside function
- `ac` - Around class
- `ic` - Inside class

### Context
- `[c` - Go to context
- `<leader>tc` - Toggle treesitter context

## AI Assistant Integration (Copilot)

### Suggestions
- `<C-]>` - Next suggestion
- `<C-[>` - Previous suggestion
- `<C-\>` - Dismiss suggestion

### Panel Controls
- `<leader>co` - Open Copilot panel
- `<leader>cdp` - Disable Copilot
- `<leader>cep` - Enable Copilot

## Settings and Features

### Editor Settings
- Line numbers enabled (relative)
- Tab width: 4 spaces
- Mouse support enabled
- System clipboard integration
- Terminal colors enabled
- Folding based on Treesitter
- Persistent undo history
- No line wrapping
- Smart indentation
- Auto-indentation

### Additional Features
- Automatic pair completion
- Git integration with line indicators
- File tree with git status
- Status line with git branch and file info
- Syntax highlighting via Treesitter
- LSP integration for multiple languages
- Fuzzy finding
- Terminal integration
- Testing framework integration
- Auto-formatting on save (where available)
- Code completion
- Diagnostics
- Symbol navigation