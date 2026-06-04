# Backup function
backup() {
    cp "$1" "$1.bak"
}

# Copy function
copy() {
    if [[ $# -eq 2 && -d "$1" ]]; then
        cp -r "$1" "$2"
    else
        cp "$@"
    fi
}

pack() {
	strip $1 && upx --lzma --best $1
}
# Change directory and list contents

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}
# General function to extract from multiple formats
# Extracts any archive(s) (if unp isn't installed)
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive>"
        return 1
    fi

    local archive="$1"
    local dest_dir

    # Get filename without extension for directory name
    local base_name=$(basename "$archive")
    local dir_name="${base_name%.*}"

    # Handle special cases for double extensions
    case "$base_name" in
        *.tar.gz|*.tgz)
            dir_name="${base_name%.tar.gz}"
            dir_name="${dir_name%.tgz}"
            ;;
        *.tar.bz2|*.tbz2)
            dir_name="${base_name%.tar.bz2}"
            dir_name="${dir_name%.tbz2}"
            ;;
        *.tar.xz|*.txz)
            dir_name="${base_name%.tar.xz}"
            dir_name="${dir_name%.txz}"
            ;;
        *.tar.zst)
            dir_name="${base_name%.tar.zst}"
            ;;
    esac

    # Create destination directory
    dest_dir="./${dir_name}"

    if [ -d "$dest_dir" ]; then
        echo "Directory '$dest_dir' already exists. Choose a different name or remove it first."
        return 1
    fi

    mkdir -p "$dest_dir"

    # Extract based on file type
    case "$archive" in
        *.tar.gz|*.tgz)
            tar -xzf "$archive" -C "$dest_dir"
            ;;
        *.tar.bz2|*.tbz2)
            tar -xjf "$archive" -C "$dest_dir"
            ;;
        *.tar.xz|*.txz)
            tar -xJf "$archive" -C "$dest_dir"
            ;;
        *.tar.zst)
            if command -v zstd &> /dev/null; then
                tar --zstd -xf "$archive" -C "$dest_dir"
            else
                echo "zstd not installed. Cannot extract .tar.zst files."
                rm -rf "$dest_dir"
                return 1
            fi
            ;;
        *.tar)
            tar -xf "$archive" -C "$dest_dir"
            ;;
        *.gz)
            if [ "${archive%.gz}" != "$archive" ]; then
                gunzip -c "$archive" > "$dest_dir/${base_name%.gz}"
            fi
            ;;
        *.bz2)
            bunzip2 -c "$archive" > "$dest_dir/${base_name%.bz2}"
            ;;
        *.xz)
            xz -dc "$archive" > "$dest_dir/${base_name%.xz}"
            ;;
        *.zip)
            if command -v unzip &> /dev/null; then
                unzip "$archive" -d "$dest_dir"
            else
                echo "unzip not installed. Cannot extract .zip files."
                rm -rf "$dest_dir"
                return 1
            fi
            ;;
        *.rar)
            if command -v unrar &> /dev/null; then
                unrar x "$archive" "$dest_dir/"
            elif command -v rar &> /dev/null; then
                rar x "$archive" "$dest_dir/"
            else
                echo "unrar/rar not installed. Cannot extract .rar files."
                rm -rf "$dest_dir"
                return 1
            fi
            ;;
        *.7z)
            if command -v 7z &> /dev/null; then
                7z x "$archive" -o"$dest_dir"
            else
                echo "7z not installed. Cannot extract .7z files."
                rm -rf "$dest_dir"
                return 1
            fi
            ;;
        *.zst)
            if command -v zstd &> /dev/null; then
                zstd -dc "$archive" > "$dest_dir/${base_name%.zst}"
            else
                echo "zstd not installed. Cannot extract .zst files."
                rm -rf "$dest_dir"
                return 1
            fi
            ;;
        *.lzma)
            lzma -dc "$archive" > "$dest_dir/${base_name%.lzma}"
            ;;
        *)
            echo "Unsupported archive format: $archive"
            rm -rf "$dest_dir"
            return 1
            ;;
    esac

    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "Successfully extracted '$archive' to '$dest_dir/'"
        # List contents if it's a small archive
        local file_count=$(find "$dest_dir" -type f | wc -l)
        if [ $file_count -le 20 ]; then
            echo "Contents:"
            find "$dest_dir" -type f | sed 's|^\./||'
        fi
    else
        echo "Failed to extract '$archive'"
        rm -rf "$dest_dir"
        return $exit_code
    fi
}
# IP address lookup
alias whatismyip="whatsmyip"
whatsmyip () {
    if [ -n "$1" ]; then
    printf "Location: $(curl -s https://am.i.mullvad.net/country), $(curl -s https://am.i.mullvad.net/city), Organization: $(curl -s https://am.i.mullvad.net/json | jq -r '.organization')\n"
    fi
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    printf "External IP: $(curl -s https://am.i.mullvad.net/ip)\n"
}
# Function for creating new rust projects with extra settings
newrust() {
    if [ $# -eq 0 ]; then
        echo "Error: Rust project name is needed" >&2
        echo "Example: newrust lol_funny_project"
        return 1
    fi
    if ! cargo new "$1"; then
        echo "Error: Failed to create project '$1'" >&2
        return 1
    fi
    cd "$1" && echo -e '\n[profile.dev.package."*"]\nopt-level = 3   # Doing this to reduce compiled package file size(can also be done by setting this to s)\n' >> Cargo.toml
}
newrustlib() {
    if [ $# -eq 0 ]; then
        echo "Error: Rust project name is needed" >&2
        echo "Example: newrustlib lol_funny_project"
        return 1
    fi
    if ! cargo new --lib "$1"; then
        echo "Error: Failed to create project '$1'" >&2
        return 1
    fi
    cd "$1" && echo -e '\n[profile.dev.package."*"]\nopt-level = 3   # Doing this to reduce compiled package file size(can also be done by setting this to s)\n' >> Cargo.toml
}
# Murder is funny
murder() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: murder <program_name>" >&2
        echo "Example: murder discord" >&2
        return 1
    fi

    local targets=()

    for arg in "$@"; do
        local pids=$(pidof "$arg")
        if [[ -z "$pids" ]]; then
            echo "Process by the name of '$arg' does not exist" >&2
        else
            targets+=($pids)
        fi
    done

    if [[ ${#targets[@]} -eq 0 ]]; then
        echo "No processes found" >&2
        return 1
    fi

    kill ${targets[@]}
}

# Helper to compile and run java with 1 command(combining javac and java)
runjava() {
    local origin=$(pwd)
    if [[ $# -eq 0 ]]; then
    	echo "Error: Java file with main entry point was not provided" >&2
        echo "Example: runjava Main.java" >&2
        return 1
        fi
    if [[ $# -gt 1 ]]; then
        echo "Error: More arguments than needed were provided" >&2
        return 1
        fi
    local target=$1
    mkdir -p /tmp/java-output/ && javac -d /tmp/java-output/ "$target" && cd /tmp/java-output && java ${target%.*} && cd $origin
    
}

newgo() {
    if [[ $# -eq 0 ]]; then
        echo "Error: Missing function argument(project name)" >&2
        echo "Example: newgo <new_project>"
        return 1
        fi
    if [[ $# -gt 1 ]]; then
        echo "Error: Too many arguments provided" >&2
        return 1
        fi
    mkdir $1 && cd $1 && go mod init $1 && touch main.go
        
}

randomjam() {
	cat /dev/urandom | hexdump -v -e '/1 "%u\n"' | awk '{ split("0,3,5,6,7,10,12",a,","); for (i = 0; i < 1; i+= 0.0001) printf("%08X\n", 100*sin(1382*exp((a[$1 % 8]/12)*log(2))*i)) }' | xxd -r -p | aplay -c 2 -f S32_LE -r 24000
}
explore-installed-package() { pacman -Ql "$1" }
explore-remote-package()    { pacman -Fl "$1" }
