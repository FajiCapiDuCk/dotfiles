#Haskell binaries
if [[ -d ~/.ghcup/bin ]]; then
export PATH="$HOME/.ghcup/bin:$PATH"
fi
#Rust custom installed stuff
if [[ -d ~/.cargo/bin ]]; then
export PATH="$HOME/.cargo/bin:$PATH"
fi
#Golang binary path
if [[ -d ~/go/bin ]]; then
export PATH="$HOME/go/bin:$PATH"
fi
