setopt prompt_subst
echo -e "\033[48;2;46;52;64;38;2;216;222;233m\033[0m\033[48;2;59;66;82;38;2;216;222;233m $(uptime -p | cut -c 4-) \033[0m\033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"
#echo -e "\x1b[38;5;137m\x1b[48;5;0m it's $(print -P '%D{%H:%M}\n') \x1b[38;5;180m\x1b[48;5;0m $(uptime -p | cut -c 4-) \x1b[38;5;223m\x1b[48;5;0m $(uname -r) \033[0m"
autoload -Uz vcs_info

zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'

precmd() {
  vcs_info

  if [[ -n "$SSH_CONNECTION" ]]; then
    RPROMPT="%n@%m"
  else
    RPROMPT=""
  fi

  if [[ $EUID -eq 0 ]]; then
    ROOT_INDICATOR="%K{red}%F{white} ROOT %f%k "
  else
    ROOT_INDICATOR=""
  fi
}
# left prompt
PROMPT='${ROOT_INDICATOR}%~${vcs_info_msg_0_}
%(?.%F{magenta}.%F{red})%(!.#.❯)%f '
