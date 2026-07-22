#!/usr/bin/env bash

# This script is intended to either
# - be run on a new machine to clean up any personal files and config
# - be run to clean up a machine before giving it away
# - be run to clean up a bad install of dotfiles
#
# It is destructive. Everything below is removed from your home directory.

set -u

# Always operate on $HOME, regardless of the current working directory
cd "$HOME" || exit 1

echo "This will permanently remove the following from $HOME:"
echo "  .config/iterm2, .config/zsh, .oh-my-zsh, .zshrc"
echo "  .ssh (keys and config), .gitconfig, .gitignore_global"
echo "  Developer/, Screenshots/"
printf "Continue? [y/N] "
read -r reply
case "$reply" in
    y | Y) ;;
    *) echo "Aborted."; exit 0 ;;
esac

# Remove iterm2 and zsh config
rm -rf .config/iterm2 .config/zsh .oh-my-zsh .zshrc

# Remove SSH keys and config
rm -rf .ssh
ssh-add -D 2>/dev/null || true

# Remove git config
rm -f .gitconfig .gitignore_global

# Remove any personal dirs and files
rm -rf Developer Screenshots

echo "Cleanup complete."
