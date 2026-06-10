#!/usr/bin/env sh
# Preloaded for Setup Module
if [ -z "$_setup_preloaded_sh__included" ]; then
_setup_preloaded_sh__included=1

# --- Parsing Arguments ---
display_help() {
cat << EOF
Usage: $0 [OPTION]...
Make configuration file for ${LIGHT_CYAN}LolPopGames'${RESET} ${CONFIG_TYPE}dotfiles

  ${BOLD}-i, --indent${RESET}
         make '=>' identation for every dialogue

  ${BOLD}-h, --help${RESET}
         display this help and exit

  ${BOLD}-v, --version${RESET}
         output version information and exit

The script will make a ${LIGHT_GREEN}config.sh${RESET} file

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit
}

# Empty mean 0, 1 mean 1
INDENT=
find_long_option() case "$1" in
    --h|--he|--hel|--help) display_help;;
    --v|--ve|--ver|--vers|--versi|--versio|--version) display_version;;
    --i|--in|--ind|--inde|--inden|--indent) INDENT=1;;
    --*) return 1;;
esac


find_option() case "$str" in
    h*) display_help;;
    v*) display_version;;
    i*) INDENT=1;;
    *) return 1;;
esac

parse_args "$@"

# --- Determining OS ---
. "$MODULES/os-info.sh"
case "$OS_COLOR_RGB" in
    [!0-9]*) OS_COLOR_RGB="'$OS_COLOR_RGB'";;
    *)       OS_COLOR_RGB="$OS_COLOR_RGB";;
esac
case "$OS_COLOR_XTERM" in
    [!0-9]*) OS_COLOR_XTERM="'$OS_COLOR_XTERM'";;
    *)       OS_COLOR_XTERM="$OS_COLOR_XTERM";;
esac
case "$OS_COLOR_BASE16" in
    [!0-9]*) OS_COLOR_BASE16="'$OS_COLOR_BASE16'";;
    *)       OS_COLOR_BASE16="$OS_COLOR_BASE16";;
esac

# --- Outputing ---
cat > "$CONFIG" << EOF
#!/usr/bin/env sh
# Configuration file for LolPopGames' ${CONFIG_NAME}dotfiles

# System Stats
OS_ICON='$OS_ICON'
OS_NAME='$OS_NAME'${LINUX_FAMILY_BRANCH:+"
LINUX_FAMILY_BRANCH='$LINUX_FAMILY_BRANCH'"}
OS_COLOR_RGB=$OS_COLOR_RGB
OS_COLOR_XTERM=$OS_COLOR_XTERM
OS_COLOR_BASE16=$OS_COLOR_BASE16

EOF

# --- Output Deps Function ---
# Usage:
#   output_deps
# Description:
#   Output $confs, $deps and $optdeps to $CONFIG
output_deps() {
    # Removing trailing whitespace
    confs="${confs# }"
    deps="${deps# }"
    optdeps="${optdeps# }"
    dep_output="${dep_output# }"

cat >> "$CONFIG" << EOF
# Configuration
CONFS='$confs'
DEPS='$deps'
OPTDEPS='$optdeps'
EOF

    # Printing dependencies
    printf 'Dependencies: %s\n' "$dep_output"
}

fi
