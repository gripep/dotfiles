#!/usr/bin/env bash

# This script points iTerm2 at the dotfiles-managed preferences folder

# Set option to load settings from a custom folder (General > Settings)
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"

killall iTerm2 || true
