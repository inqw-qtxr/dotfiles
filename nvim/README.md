# Neovim Configuration

A modern, feature-rich Neovim configuration focused on providing a complete IDE-like experience. This configuration includes support for multiple languages, debugging, Git integration, and various quality-of-life improvements.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Plugin Overview](#plugin-overview)
- [Keybindings](#keybindings)
  - [General](#general)
  - [LSP & Code Navigation](#lsp--code-navigation)
  - [File Navigation](#file-navigation)
  - [Git Integration](#git-integration)
  - [Terminal Integration](#terminal-integration)
  - [Language Specific](#language-specific)
  - [Debugging](#debugging)
  - [Completion & Snippets](#completion--snippets)
  - [Code Formatting & Comments](#code-formatting--comments)
  - [Database Operations](#database-operations)
  - [Text Manipulation](#text-manipulation)

## ✨ Features

- Modern LSP integration with rich completion support
- Integrated debugging support
- Git integration
- Fuzzy finding with Telescope
- File tree navigation
- Terminal integration
- Language-specific enhancements for:
  - TypeScript/JavaScript
  - Python
  - Go
  - Ruby/Rails
  - C/C++
  - Lua
  - and more...

## 📦 Requirements

- Neovim >= 0.9.0
- Git
- A C compiler (for tree-sitter)
- Node.js (for LSP servers)
- ripgrep (for Telescope)
- A Nerd Font (for icons)

## 🚀 Installation

1. Backup your existing Neovim configuration:
```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this configuration:
```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

3. Start Neovim - plugins will be automatically installed on first launch.

## 🔌 Plugin Overview

### Core Plugins

- **lazy.nvim**: Plugin manager
- **nvim-lspconfig**: LSP configuration
- **nvim-treesitter**: Advanced syntax highlighting
- **telescope.nvim**: Fuzzy finder and picker
- **nvim-cmp**: Completion engine
- **mason.nvim**: LSP/DAP/Linter manager

### Language Support

- **TypeScript**
  - typescript-tools.nvim: Enhanced TypeScript support
  - prettier.nvim: Code formatting

- **Python**
  - nvim-dap-python: Debugging support
  - black: Code formatting
  - ruff: Linting

- **Go**
  - go.nvim: Enhanced Go support
  - gofumpt: Code formatting
  - delve: Debugging

- **Ruby**
  - vim-rails: Rails support
  - vim-ruby: Ruby support
  - solargraph: Language server

### Editor Enhancement

- **nvim-tree.lua**: File explorer
- **barbar.nvim**: Buffer management
- **gitsigns.nvim**: Git integration
- **toggleterm.nvim**: Terminal integration
- **nvim-autopairs**: Automatic bracket pairs
- **Comment.nvim**: Enhanced commenting
- **nvim-surround**: Surround text operations
- **leap.nvim**: Quick navigation
- **harpoon**: File marking and quick navigation

### Visual Enhancement

- **gruvbox.nvim**: Color scheme
- **nvim-web-devicons**: File icons
- **lualine.nvim**: Status line
- **nvim-notify**: Notification manager

### Tools Integration

- **nvim-dap**: Debug adapter protocol
- **trouble.nvim**: Problem lists
- **telescope.nvim**: Fuzzy finder
- **vim-dadbod**: Database integration

## ⌨️ Keybindings

> Leader key is set to `\`

### General

#### Editor Controls
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>sr` - Reload configuration

#### Buffer Navigation
- `<A-,>` - Previous buffer
- `<A-.>` - Next buffer
- `<A-<>` - Move buffer left
- `<A->>` - Move buffer right
- `<A-1-9>` - Go to buffer 1-9
- `<A-0>` - Go to last buffer
- `<A-c>` - Close buffer

### LSP & Code Navigation

#### Code Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>D` - Type definition

#### Diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>e` - Show diagnostic in float
- `<leader>q` - Send diagnostics to quickfix

### File Navigation

#### Telescope
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse files
- `<leader>fr` - Recent files
- `<leader>fh` - Help tags
- `<leader>fs` - Find symbols

#### NvimTree
- `<leader>E` - Toggle file explorer
- `<leader>ef` - Focus current file
- `<leader>ec` - Collapse file explorer

#### Harpoon
- `<leader>ha` - Add file to harpoon
- `<leader>he` - Toggle quick menu
- `<C-h>` - Navigate to file 1
- `<C-j>` - Navigate to file 2
- `<C-k>` - Navigate to file 3
- `<C-l>` - Navigate to file 4

### Git Integration

#### Gitsigns
- `]c` - Next hunk
- `[c` - Previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hb` - Blame line
- `<leader>hp` - Preview hunk
- `<leader>hd` - Diff this

#### Git Commands (Telescope)
- `<leader>gc` - Git commits
- `<leader>gf` - Git files
- `<leader>gb` - Git branches
- `<leader>gs` - Git status

### Terminal Integration

- `<C-\>` - Toggle terminal
- `<leader>tt` - Toggle terminal
- `<leader>tg` - Toggle lazygit
- `<leader>tn` - Toggle node REPL
- `<leader>tp` - Toggle python REPL
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal

### Language Specific

#### TypeScript/JavaScript
- `<leader>tsi` - Organize imports
- `<leader>tsa` - Add missing imports
- `<leader>tsf` - Fix all
- `<leader>tsr` - Rename file
- `<leader>tsd` - Go to source definition

#### Python
- `<leader>pt` - Run current file
- `<leader>dpr` - Debug test method
- `<leader>dpc` - Debug test class
- `<leader>dps` - Debug selection

#### Go
- `<leader>gr` - Run
- `<leader>gt` - Test
- `<leader>gi` - Implement interface
- `<leader>gf` - Fill struct

#### Ruby/Rails
- `<leader>Ra` - Rails actions
- `<leader>Rc` - Rails controller
- `<leader>Rm` - Rails model
- `<leader>Rv` - Rails view

### Debugging

- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dt` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dl` - Run last
- `<leader>dr` - Open REPL

### Completion & Snippets

- `<C-Space>` - Trigger completion
- `<C-n>` - Next completion item
- `<C-p>` - Previous completion item
- `<C-f>` - Scroll docs forward
- `<C-b>` - Scroll docs backward
- `<CR>` - Confirm completion

### Code Formatting & Comments

- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `<leader>/` - Toggle comment
- `<leader>cf` - Format code

### Database Operations

- `<leader>db` - Toggle database UI
- `<leader>dba` - Add connection
- `<leader>dbf` - Find buffer
- `<leader>dbl` - Last buffer

### Text Manipulation

#### Surround Operations
- `ys{motion}{char}` - Add surround
- `ds{char}` - Delete surround
- `cs{target}{replacement}` - Change surround

#### Quick Movement (Leap)
- `s` - Leap forward
- `S` - Leap backward
- `gs` - Leap from windows

## 📝 Notes

- The configuration auto-installs plugins on first launch
- Custom configurations can be added to `lua/custom/init.lua`
- LSP servers are automatically installed via Mason
- Format on save is enabled by default for supported languages