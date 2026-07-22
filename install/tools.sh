#!/usr/bin/env bash

# This script installs tools that are not installed via Homebrew, but are still needed for development.
# These tools are better installed via their own installation methods because of specific configuration needs
# or dependencies clashes with Homebrew packages.

install_gemini_cli() {
    # gemini-cli (Google Gemini AI models cli tool)
    if is-executable gemini; then
        return
    fi
    echo "gemini-cli not found. Installing..."

    # Load nvm into the current shell (installed via homebrew).
    # N.B. File .langs sources this for interactive shells, but not during install
    export NVM_DIR="$HOME/.nvm"
    mkdir -p "$NVM_DIR"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

    nvm install stable  # installs latest stable node + npm, and switches to it
    npm install -g @google/gemini-cli
}

install_gemini_cli
