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

# Detect the operating system
OS="$(uname -s)"

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p ~/.config/{alacritty,nvim,ghostty}
mkdir -p ~/.ssh
mkdir -p ~/.local/bin

# Install packages based on the operating system
case "$OS" in
    Darwin)
        # macOS specific installation
        print_status "Detected macOS"

        # Install Homebrew if not installed
        if ! command -v brew &> /dev/null; then
            print_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            print_status "Homebrew already installed, updating..."
            brew update
        fi

        # Install packages from Brewfile
        print_status "Installing packages from Brewfile..."
        brew bundle install --file="$DOTFILES/brew/Brewfile"
        ;;
    Linux)
        # Linux specific installation
        print_status "Detected Linux"

        # Install packages using apt or yum
        if command -v apt &> /dev/null; then
            print_status "Installing packages using apt..."
            sudo apt update
            sudo apt install -y git vim neovim tmux zsh fzf ripgrep fd-find bat htop jq tree gh lazygit cmake g++ build-essential
        elif command -v yum &> /dev/null; then
            print_status "Installing packages using yum..."
            sudo yum install -y git vim neovim tmux zsh fzf ripgrep fd-find bat htop jq tree gh lazygit cmake gcc-c++ make
        else
            print_error "Neither apt nor yum found. Please install packages manually."
            exit 1
        fi
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        # Windows specific installation
        print_status "Detected Windows"

        # Install packages using Chocolatey
        if ! command -v choco &> /dev/null; then
            print_status "Installing Chocolatey..."
            /bin/bash -c "$(curl -fsSL https://chocolatey.org/install.sh)"
        else
            print_status "Chocolatey already installed, updating..."
            choco upgrade chocolatey
        fi

        # Install packages using choco
        print_status "Installing packages using choco..."
        choco install git vim neovim tmux zsh fzf ripgrep fd bat htop jq tree gh lazygit cmake
        ;;
    *)
        print_error "Unsupported operating system: $OS"
        exit 1
        ;;
esac

# Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Zprezto
print_status "Installing Zprezto..."
source "$DOTFILES/zsh/zprezto/install.sh"

# Install powerlevel10k if not installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_status "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Create symbolic links
print_status "Creating symbolic links..."

# Backup existing configurations
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Function to create symbolic link with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Backup existing file/directory if it exists
    if [ -e "$target" ]; then
        mv "$target" "$backup_dir/"
    fi
    
    # Create symbolic link
    ln -sf "$source" "$target"
}

# Create symbolic links for all configurations
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

create_symlink "$DOTFILES/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
create_symlink "$DOTFILES/alacritty/gruvbox-theme.toml" "$HOME/.config/alacritty/gruvbox-theme.toml"
create_symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/zsh/p10k.zsh" "$HOME/.p10k.zsh"
create_symlink "$DOTFILES/zsh/aliases" "$HOME/.aliases"
create_symlink "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
create_symlink "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# macOS specific symbolic link
if [[ "$OS" == "Darwin" ]]; then
    create_symlink "$DOTFILES/mozilla/user.js" "$HOME/Library/Application Support/Firefox/Profiles/*.default/user.js"
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_status "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set ZSH as default shell if it isn't already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_status "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
fi

print_success "Installation complete! Please restart your terminal."
print_status "Note: If you see any backup files in $backup_dir, your old configurations were preserved there."
