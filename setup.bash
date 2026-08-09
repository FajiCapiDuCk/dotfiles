#!/usr/bin/env bash

action=""
config=""
usage() {
    echo "Usage: $0 <link|unlink> <laptop|laptop_i3|desktop|zsh>"
    echo "Description: Specific options symlink or remove symlinks from specific config files"
    exit 1
}

if [[ $# -eq 0 ]]; then
    usage
    fi
    
if [[ $# -gt 2 ]]; then
    usage
    fi
    
case $1 in
    "link") action=$1 ;;
    "unlink") action=$1 ;;
    *) usage ;;
    esac
    
case $2 in
    "laptop") config=$2 ;;
    "laptop_i3") config=$2 ;;
    "desktop") config=$2 ;;
    "zsh") config=.zsh ;;
    *) usage ;;
    esac
    
strip_last_component() {
  local p=${1:?path required}

  # If there's no slash, return "."
  [[ $p == */* ]] || { printf '.\n'; return; }

  # Remove the last /component
  p=${p%/*}
  [[ -z $p ]] && p=/
  printf '%s\n' "$p"
}


if [[ "$config" == ".zsh" ]]; then
    [[ "$PWD" == "$HOME/dotfiles" ]] || echo "Not in dotfiles folder please cd into it" >&2 && exit 1
    if [[ "$action" == "unlink" && -L "~/.zshrc" ]]; then
        rm ~/.zshrc
        [[ -L ~/.zsh ]] || exit 0
        rm ~/.zsh
        exit 0
        else
        echo "Nothing to unlink for zsh"
        exit 0
        fi
    if [[ -f "~/.zshrc" && ! -L "~/.zshrc" ]]; then
        mv ~/.zshrc ~/.zshrc.bak
        fi
    ln -s .zsh ~/.zsh
    ln -s .zshrc ~/.zshrc
    exit 0
    fi
    
link_dotconfig_tree() {
    local cfg="$1"

    local src_root="$HOME/dotfiles/$cfg/.config"
    local dest_root="$HOME/.config"

    [[ -d "$src_root" ]] || { echo "No config tree: $src_root" >&2; exit 1; }

    # Link mode: create symlinks for everything under src_root (except src_root itself)
    if [[ "$action" == "link" ]]; then
        while IFS= read -r -d '' path; do
            local rel="${path#"$src_root"/}"
            local dest="${dest_root}/${rel}"
            echo $dest
            mkdir -p "$(strip_last_component "$dest")"

            # If dest exists:
            if [[ -e "$dest" || -L "$dest" ]]; then
                        continue
                fi

                # Don't overwrite non-symlink files
                if [[ ! -L "$dest" && -f "$dest" ]]; then
                    echo "Conflict at: $dest (exists and is not a symlink)" >&2
                    continue
                fi

            ln -s "$path" "$dest"
        done < <(find "$src_root" -type f -print0)

        exit 0
    fi

    # Unlink mode: remove only symlinks that point into this config's src_root
    if [[ "$action" == "unlink" ]]; then
        while IFS= read -r -d '' path; do
            local rel="${path#"$src_root"/}"
            local dest="${dest_root}/${rel}"

            if [[ -L "$dest" ]]; then
                local cur
                currrent="$(readlink "$dest")"
                if [[ "$cur" == "$path" ]]; then
                    rm -f "$dest"
                fi
            fi
        done < <(find "$src_root" -type f -print0)

        exit 0
    fi
}
   
link_dotconfig_tree "$config"

