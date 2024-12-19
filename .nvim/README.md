# Neovim Configuration Cheatsheet

> Note: Leader key is set to `\`

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
- `gV` - Select last inserted text

## Window Management
- `<leader>sh` - Split horizontally
- `<leader>se` - Make splits equal size
- `<C-h/j/k/l>` - Navigate between windows (works in both normal and terminal mode)

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

## Code Editing

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
- Visual Mode: `S{char}` - Surround selection

### Auto-Pairs
- `<M-e>` - Fast wrap (Alt+e)

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

## Git Operations (Gitsigns)

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

## Terminal Operations (Toggleterm)
- `<C-\>` - Toggle floating terminal
- `<leader>tt` - Toggle terminal
- `<leader>tg` - Toggle lazygit
- `<leader>tn` - Toggle Node REPL
- `<leader>tp` - Toggle Python REPL

### Terminal Mode Navigation
- `<esc>` or `jk` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate between windows

## GitHub Copilot
- `<Tab>` - Accept suggestion
- `<C-]>` - Next suggestion
- `<C-[>` - Previous suggestion
- `<C-\>` - Dismiss suggestion
- `<leader>co` - Open Copilot panel
- `<leader>cdp` - Disable Copilot
- `<leader>cep` - Enable Copilot

## Code Navigation & Selection
- `gnn` - Initialize Treesitter selection
- `grn` - Increment selection by node
- `grc` - Increment selection by scope
- `grm` - Decrement selection

### Text Objects
- `af` - Around function
- `if` - Inside function
- `ac` - Around class
- `ic` - Inside class

## Context Viewing
- `[c` - Go to context
- `<leader>tc` - Toggle treesitter context