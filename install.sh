#!/usr/bin/env bash

# Run everything in a subshell so that `source`-ing this script (as the README
# instructs) cannot leak `set -e`/`exit` into, and kill, the caller's shell.
(
set -eu -o pipefail

# Get current dotfiles dir to run this script from anywhere
export DOTFILES_DIR="$HOME/.dotfiles"

# Make dotfiles commands and executable files available
PATH="$DOTFILES_DIR/bin:$PATH"

# This setup targets Apple Silicon (arm64) only
if ! is-arm64; then
    echo "This setup targets Apple Silicon (arm64) Macs only. Detected $(uname -m). Exiting..."
    exit 1
fi

# The .env file is required for the GitHub SSH setup below
if [ ! -f "$DOTFILES_DIR/system/.env" ]; then
    echo "Missing $DOTFILES_DIR/system/.env"
    echo "Copy system/.env.example to system/.env, fill it in, then re-run."
    echo "Make sure to read $DOTFILES_DIR/README.md"
    exit 1
fi

# Make dotfiles up-to-date first if available (pull latest changes if git is available)
if is-executable git && [ -d "$DOTFILES_DIR/.git" ]; then
    echo "Pulling latest changes from the dotfiles repository..."
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin main
fi

# System setup
if is-macos; then
    echo "Setting up macOS environment..."

    # Set up development directories
    echo "Creating base directories for development..."
    mkdir -p $HOME/.config
    mkdir -p $HOME/Developer/{bin,opt,src,tmp}
else
    echo "Currently only macOS is supported. Exiting..."
    exit
fi
# Create the .custom file for ad-hoc aliases, commands, etc...
touch "$DOTFILES_DIR/system/.custom"

# Install Homebrew (if not installed), and apps and tools
. "$DOTFILES_DIR/install/homebrew.sh" || true

# Install Oh-My-Zsh
. "$DOTFILES_DIR/install/oh-my-zsh.sh"

# Create symlinks for relevant dotfiles
ln -sfv "$DOTFILES_DIR/git/.gitconfig" "$HOME"
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" "$HOME"

ln -svf "$DOTFILES_DIR/iterm2/themes" "$HOME/.config/iterm2"

ln -sfv "$DOTFILES_DIR/zsh/.zshrc" "$HOME"
ln -sfv "$DOTFILES_DIR/zsh/.history.zsh" "$HOME/.config/zsh/.history.zsh"
ln -sfv "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.config/zsh/.p10k.zsh"

# GitHub setup
. "$DOTFILES_DIR/install/github-autokey.sh"

# Install tools (that are not installed via Homebrew)
. "$DOTFILES_DIR/install/tools.sh"

# Install projects
. "$DOTFILES_DIR/install/projects.sh"
)
