#!/usr/bin/env sh
# Preloaded for Install Module
if [ -z "$_install_preloaded_sh__included" ]; then
_install_preloaded_sh__included=1

# --- Parsing Arguments ---
display_help() {
cat << EOF
Usage: $0 [OPTION]...
Install ${LIGHT_CYAN}LolPopGames'${RESET} dotfiles

  ${BOLD}-h, --help${RESET}
         display this help and exit

  ${BOLD}-v, --version${RESET}
         output version information and exit

The script requires ${LIGHT_GREEN}config.sh${RESET} file that can be generated with ${LIGHT_GREEN}setup.sh${RESET}

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit
}

find_long_option() {
    case "$1" in
        --h|--he|--hel|--help) display_help;;
        --v|--ve|--ver|--vers|--versi|--versio|--version) display_version;;
        --*) return 1;;
    esac
}
find_option() {
    case "$str" in
        h*) display_help;;
        v*) display_version;;
        *) return 1;;
    esac
}

parse_args "$@"
load_config || :

# --- Not Same Link Function ---
# Usage:
#   not_same_link "file" "file"
# Description:
#   Check if two files are same with expanding symlinks
not_same_link() {
    [ "$(readlink -m "$1")" != "$(readlink -m "$2")" ]
}

# --- Link It Function ---
# Usage:
#   link_it "link-name" "target"
# Description:
#   Similar to ln, but removes symlink location file to always create a symlink
link_it() {
    if not_same_link "$1" "$2"; then
        rm -rf "$1"
        ln -s "$2" "$1"
    fi
}

# Configs Dir
CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

fi
