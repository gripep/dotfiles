#!/usr/bin/env bash

# This script is intended to either
# - be run on a new machine to clean up any personal files and config
# - be run to clean up a machine before giving it away
# - be run to clean up a bad install of dotfiles

# Remove item2 and zsh config
rm -rf .config/iterm2/themes .config/zsh .oh-my-zsh .zshrc

# Remove SSH keys and config
rm -r .ssh/*
ssh-add -D

# Remove git config
rm .gitconfig .gitignore_global

# Remove any personal dirs and files
rm -rf Developer Screenshots
