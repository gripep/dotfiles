#!/urs/bin/env bash

# This script installs Oh My Zsh, and its plugins and themes

ZSH_DIR="$HOME/.config/zsh"

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# Move the Oh My Zsh installation to the correct directory
# The .zshrc will make sure to point to the right place and not the default $HOME/.oh-my-zsh
mkdir -p $ZSH_DIR
mv $HOME/.oh-my-zsh $ZSH_DIR/.oh-my-zsh
# Any previous .zshrc will be renamed to .zshrc.pre-oh-my-zsh
if test -f .zshrc.pre-oh-my-zsh; then
    echo "Updating existing .zshrc file..."
    rm .zshrc
    mv .zshrc.pre-oh-my-zsh .zshrc
fi


# Set ZSH custom dir to store plugins and themes in the right place
OMZ_CUSTOM_DIR="$ZSH_DIR/.oh-my-zsh/custom"

echo "Installing Oh My Zsh plugins and theme..."
# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${OMZ_CUSTOM_DIR:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# Install zsh-completions plugin
git clone https://github.com/zsh-users/zsh-completions.git ${OMZ_CUSTOM_DIR:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions
# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${OMZ_CUSTOM_DIR:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install  Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${OMZ_CUSTOM_DIR:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Oh My Zsh and plugins installed successfully."
