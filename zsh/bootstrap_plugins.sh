#!/bin/bash

set -e

# Detect platform
PLATFORM=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            PLATFORM="ubuntu"
        fi
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="mac"
fi

# Install packages
install_packages() {
    echo "Installing required packages for $PLATFORM..."
    if [[ "$PLATFORM" == "ubuntu" ]]; then
        sudo apt update
        sudo apt install -y zsh tmux neovim git curl vim autojump
    elif [[ "$PLATFORM" == "mac" ]]; then
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh tmux neovim git curl vim autojump
    else
        echo "Unsupported platform. Please install zsh, tmux, and neovim manually."
        exit 1
    fi
}

install_packages

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s $(which zsh)
fi

# Install Oh My Tmux
if [ ! -d "$HOME/.tmux" ]; then
    echo "Installing Oh My Tmux..."
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux || true
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
    cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local 2>/dev/null || true
fi

# Define dotfiles directory
DOTFILES_DIR=$(pwd)

# Ensure required directories exist
mkdir -p ~/.config/nvim

# Symlinks
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" ~/.p10k.zsh

# Zsh Plugin Installation
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
echo "Installing Zsh plugins..."
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true

# Tmux Plugin Manager (TPM)
echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# Done
echo "Dotfiles setup complete!"
