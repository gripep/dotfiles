#!/usr/bin/env bash

# This script installs apps and tools using Homebrew on macOS

# Homebrew should already be installed on macOS
# If it's not, we can install it here
if ! is-executable brew; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "Adding Homebrew to PATH..."
    echo >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed. Continue..."
fi

# Update Homebrew before installing anything
echo "Updating Homebrew..."
brew update

# Install all our apps and tools with bundle (see Brewfile)
echo "Installing apps and tools from Brewfile..."
brew bundle --file $DOTFILES_DIR/install/Brewfile || exit

echo "Apps and tools installation complete."
