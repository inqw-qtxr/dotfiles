#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_status() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}==>${NC} $1"
}

# Ask for confirmation
read -p "This will remove all dotfile symbolic links and configurations. Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Uninstall cancelled"
    exit 1
fi

# Remove symbolic links
print_status "Removing symbolic links..."
remove_symlink() {
    if [ -L "$1" ]; then
        rm "$1"
        print_status "Removed symlink: $1"
    fi
}

remove_symlink "$HOME/.config/alacritty/alacritty.toml"
remove_symlink "$HOME/.config/alacritty/gruvbox-theme.toml"
remove_symlink "$HOME/.config/nvim"
remove_symlink "$HOME/.tmux.conf"
remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.p10k.zsh"
remove_symlink "$HOME/.aliases"
remove_symlink "$HOME/.gitconfig"
remove_symlink "$HOME/.gitignore_global"
remove_symlink "$HOME/.config/ghostty/config"
remove_symlink "$HOME/Library/Application Support/Firefox/Profiles/*.default/user.js"

# Ask if user wants to remove installed packages
read -p "Do you want to remove installed packages (brew packages, oh-my-zsh, etc.)? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove Homebrew packages
    print_status "Removing Homebrew packages..."
    brew uninstall neovim tmux zsh ghostty alacritty

    # Remove oh-my-zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_status "Removing Oh My Zsh..."
        rm -rf "$HOME/.oh-my-zsh"
    fi

    # Remove powerlevel10k
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        print_status "Removing Powerlevel10k..."
        rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi

    # Remove Tmux Plugin Manager
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        print_status "Removing Tmux Plugin Manager..."
        rm -rf "$HOME/.tmux/plugins/tpm"
    fi
fi

# Restore backup if it exists
latest_backup=$(ls -td "$HOME/.dotfiles_backup_"* 2>/dev/null | head -n1)
if [ -n "$latest_backup" ]; then
    print_status "Found backup at: $latest_backup"
    read -p "Do you want to restore the backup? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Restoring backup..."
        cp -R "$latest_backup/"* "$HOME/"
        print_success "Backup restored!"
    fi
fi

print_success "Uninstallation complete!"