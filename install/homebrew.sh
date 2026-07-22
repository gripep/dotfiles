#!/usr/bin/env bash

# This script installs apps and tools using Homebrew on macOS

# Homebrew should already be installed on macOS
# If it's not, we can install it here
if ! is-executable brew; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installation complete."
else
    echo "Homebrew is already installed. Continue..."
fi

# Load brew into the CURRENT (non-interactive) shell so the rest of this
# script can use it (Apple Silicon prefix, this setup targets Mac >= M1).
# N.B. File .zshrc only affects future interactive shells.
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew before installing anything
echo "Updating Homebrew..."
brew update

# Install all our apps and tools with bundle (see Brewfile)
echo "Installing apps and tools from Brewfile..."
brew bundle --file "$DOTFILES_DIR/install/Brewfile" || exit

echo "Apps and tools installation complete."
