#!/usr/bin/env bash

# This script installs tools that are not installed via Homebrew, but are still needed for development.
# These tools are better installed via their own installation methods because of specific configuration needs
# or dependencies clashes with Homebrew packages.

# gemini-cli (Google Gemini AI models cli tool)
if ! command -v nvm &> /dev/null; then
    # Check if nvm was installed, if not install it via Homebrew
    echo "nvm not found. Installing nvm via Homebrew..."
    brew install nvm
fi
if ! nvm use stable &> /dev/null; then
    # Check if nvm use stable works, otherwise install stable
    # The version stable is the latest stable version of Node.js
    echo "No stable Node.js version found. Installing stable..."
    nvm install stable
fi
nvm use stable
# Install gemini-cli globally
npm install -g @google/gemini-cli
