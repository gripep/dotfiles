#!/usr/bin/env bash

# This script installs tools that are not installed via Homebrew, but are still needed for development.
# These tools are better installed via their own installation methods because of specific configuration needs
# or dependencies clashes with Homebrew packages.

install_gemini_cli() {
    # gemini-cli (Google Gemini AI models cli tool)
    if command -v gemini &> /dev/null; then
        return
    fi
    echo "gemini-cli not found. Installing..."
    export NVM_DIR="$HOME/.nvm"
    nvm use stable
    npm install -g @google/gemini-cli
}

install_gemini_cli
