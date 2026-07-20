#!/usr/bin/env bash

# This script installs Oh My Zsh, and its plugins and themes

ZSH_DIR="$HOME/.config/zsh"
OMZ_DIR="$ZSH_DIR/.oh-my-zsh"

# Install Oh My Zsh (skip if already installed)
if [ ! -d "$OMZ_DIR" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Move the Oh My Zsh installation to the correct directory
    # The .zshrc points here instead of the default $HOME/.oh-my-zsh
    mkdir -p "$ZSH_DIR"
    mv "$HOME/.oh-my-zsh" "$OMZ_DIR"
else
    echo "Oh My Zsh already installed. Continue..."
fi

# Custom dir to store plugins and themes in the right place
PLUGINS_DIR="$OMZ_DIR/custom/plugins"
THEMES_DIR="$OMZ_DIR/custom/themes"

echo "Installing Oh My Zsh plugins and theme..."
# Clone each plugin/theme only if it isn't there already (safe to re-run)
[ -d "$PLUGINS_DIR/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
[ -d "$PLUGINS_DIR/zsh-completions" ] || git clone https://github.com/zsh-users/zsh-completions.git "$PLUGINS_DIR/zsh-completions"
[ -d "$PLUGINS_DIR/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
[ -d "$THEMES_DIR/powerlevel10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"

echo "Oh My Zsh and plugins installed successfully."
