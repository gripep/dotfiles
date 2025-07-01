# Path to the zsh configuration directory
ZSH_DIR="$HOME/.config/zsh"

# Custom path to the oh-my-zsh installation
export ZSH="$ZSH_DIR/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set & apply plugins
plugins=(
    brew
    # copyfile
    # copypath
    # extract
    # fzf
    # fzf-tab
    git
    # git-extras
    # tmux
    # tmuxinator
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Apply current powerlevel10k configuration
# Run `p10k configure` to customise
source $ZSH_DIR/.p10k.zsh

# Source the system dotfiles for alias, path, and other config
DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/sys/.{env,langs,alias}; do
    [ -f "$DOTFILE" ] && source "$DOTFILE"
done
