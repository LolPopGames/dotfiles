#!/usr/bin/env sh
# Preloaded Module
if [ -z "$_preloaded_sh__included" ]; then
_preloaded_sh__included=1

# --- Misc ---
set -e
[ -n "$ZSH_VERSION" ] && setopt SH_WORD_SPLIT NO_FUNCTION_ARGZERO

# --- Constants ---
DIR="$(dirname "$(readlink -m "$0")")"
CONFIG="$DIR/config.sh"
if [ -d "$DIR/modules" ]; then
    MODULES="$DIR/modules"
else
    MODULES="$DIR/../../modules"
fi

# Adding CONFIG_NAME for ./script.sh --help (LolPopGames' ${CONFIG_NAME}dotfiles)
if [ ! -d "$DIR/.git" ]; then
    CONFIG_NAME="$(basename "$DIR") "
fi

# --- Version Function --- 
# Usage:
#   display_version
# Description:
#   Displays version and exits the program
display_version() {
cat << EOF
${LIGHT_CYAN} __        _______${RESET}      ${LIGHT_CYAN}LolPopGames'${RESET} dotfiles version ${BOLD}2.0.0-dev${RESET}
${LIGHT_CYAN}/  \\      /   __  \\${RESET}
${LIGHT_CYAN}|  |      |  |__|  |${RESET}    Included configurations:
${LIGHT_CYAN}|  |      |  _____/${RESET}       ${LIGHT_GREEN}cava${RESET}, ${LIGHT_GREEN}gdb${RESET}, ${LIGHT_GREEN}hypr${RESET}, ${LIGHT_GREEN}kitty${RESET}, ${LIGHT_GREEN}mako${RESET},
${LIGHT_CYAN}|  |___   |  |${RESET}            ${LIGHT_GREEN}mintty${RESET}, ${LIGHT_GREEN}rofi${RESET}, ${LIGHT_GREEN}uwsm${RESET}, ${LIGHT_GREEN}vim${RESET}, ${LIGHT_GREEN}waybar${RESET},
${LIGHT_CYAN}\\______)  \\__/${RESET}            ${LIGHT_GREEN}zsh${RESET}.
EOF
    exit
}

# --- Load Config Function ---
# Usage:
#   load_config
# Description:
#   Loads $CONFIG or displays error and exits
load_config() {
    if [ ! -f "$DIR/setup.sh" ]; then
        return 1
    elif [ -f "$CONFIG" ]; then
        . "$CONFIG"
    else

cat >&2 << EOF
config.sh: No such file or directory
Generate config.sh with setup.sh.
EOF
        exit 1
    fi
}

# --- Loading Modules ---
. "$MODULES/colors.sh"
. "$MODULES/args.sh"
. "$MODULES/deps.sh"
case "$(basename "$0")" in
    setup.sh)        . "$MODULES/preloaded/setup.sh";;
    install-deps.sh) . "$MODULES/preloaded/install-deps.sh";;
    install.sh)      . "$MODULES/preloaded/install.sh";;
esac

fi
