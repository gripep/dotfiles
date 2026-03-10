#!/usr/bin/env bash

# This script installs apps and tools using Homebrew on macOS

# Homebrew should already be installed on macOS
# If it's not, we can install it here
if ! is-executable brew; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "N.B. Homebrew is already added to the PATH in the .zshrc file, so we don't need to do anything else here."
    echo "Homebrew installation complete."
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
