eval "$(oh-my-posh init zsh --config $HOME/dotfiles/.zsh/zen.yaml)"
HIST_STAMPS="dd/mm/yyyy"
# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
   export VISUAL='nano'
 fi
# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
bindkey -e
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit -c
# Format man pages
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export EDITOR=nano
export VISUAL=nano

# Environment setup

# Add ~/.local/bin to PATH
if [[ -d ~/.local/bin && ! "$PATH" =~ "~/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

setopt HIST_VERIFY
export ZSH_CONFIG_DIR="$HOME/.zsh"
for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
    if [ -f "$config_file" ]; then
        source "$config_file"
    fi
done
# Load plugins
source ~/dotfiles/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source ~/dotfiles/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
