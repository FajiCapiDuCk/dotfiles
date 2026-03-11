eval "$(oh-my-posh init zsh --config $HOME/dotfiles/.zsh/zen.yaml)"
HIST_STAMPS="dd/mm/yyyy"
# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
   export VISUAL='nano'
 fi
# Load plugins
source ~/dotfiles/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/.zsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-or-beginning-search

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
