# Alias for opening rust std docs
alias ruststd='rustup docs --std'

# Alias to compile a go program without doxing your working environment via stack trace
alias gonodox='go build -gcflags=-trimpath=$(pwd) -asmflags=-trimpath=$(pwd) .'
# Alias for finding instances of something in codebase
alias findhere='grep -rn'

# Alias for faster fastfetch
alias ff='fastfetch'

# Alias to fix vencord when discord updates
alias fixdiscord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'

# Useful aliases
alias ls='eza -ha --color=always --group-directories-first --icons'
alias ll='eza -lha --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -e "^\."'

# Common use aliases
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Colorized output aliases
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System and package management aliases
alias hw='hwinfo --short'
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg='pacman -Q | grep -i "-git" | wc -l'
alias update='sudo pacman -Syu'

# Get fastest mirrors
alias mirror='sudo cachyos-rate-mirrors'

# Help new Arch users
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Get error messages from journalctl
alias jctl='journalctl -p 3 -xb'
# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias whereami='pwd'
