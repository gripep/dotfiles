#!/usr/bin/env bash

set -eu -o pipefail

# Get current dotfiles dir to run this script from anywhere
export DOTFILES_DIR="$HOME/.dotfiles"

# Make dotfiles commands and executable files available
PATH="$DOTFILES_DIR/bin:$PATH"

# Make dotfiles up-to-date first if available (pull latest changes if git is available)
if is-executable git && -d "$DOTFILES_DIR/.git"; then
    echo "Pulling latest changes from the dotfiles repository..."
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
fi

# System setup
if is-macos; then
    echo "Setting up macOS environment..."

    # Set up general directories
    echo "Creating general directories..."
    mkdir -p $HOME/Screenshots
    # Set up development directories
    echo "Creating base directories for development..."
    mkdir -p $HOME/.config
    mkdir -p $HOME/Developer/{bin,opt,src,tmp}
else
    echo "Currently only macOS is supported. Exiting..."
    exit
fi

# Install Homebrew (if not installed), and apps and tools
. "$DOTFILES_DIR/install/homebrew.sh" || true

# Install Oh-My-Zsh
. "$DOTFILES_DIR/install/oh-my-zsh.sh"

# Create symlinks for relevant dotfiles
ln -sfv "$DOTFILES_DIR/git/.gitconfig" "$HOME"
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" "$HOME"

ln -sfv "$DOTFILES_DIR/zsh/.zshrc" "$HOME"
ln -sfv "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.config/zsh/.p10k.zsh"

# GitHub setup
. "$DOTFILES_DIR/install/github-autokey.sh"

# Install projects
. "$DOTFILES_DIR/install/projects.sh"
