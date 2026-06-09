#!/usr/bin/env sh

# --- Showing help if --help was entered ---
case "$1" in (-h|--h|--he|--hel|--help)
    ESC="$(printf '\033')"
    BOLD="$ESC[1m"
    RESET="$ESC[0m"

cat << EOF
Usage: $0 [OPTION]...
Make configuration file for LolPopGames' dotfiles

  ${BOLD}-h, --help${RESET}
         display this help and exit

The script will make a config.sh file

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit;;
esac

# --- Working Directory, Config and Modules ---
DIR="$(dirname $(readlink -m "$0"))"
CONFIG="$DIR/config.sh"
MODULES="$DIR/modules"

# --- Start Filling $CONFIG ---
cat > "$CONFIG" << EOF
#!/usr/bin/env sh
# Configuration file for LolPopGames' dotfiles

EOF

# --- Enabling exiting on errors ---
set -e
cat >> "$CONFIG" << EOF
# Enabling exiting on errors
set -e

EOF

# --- Enabling capability mode for Zsh ---
if [ -n "$ZSH_VERSION" ]; then
    setopt SH_WORD_SPLIT
fi
cat >> "$CONFIG" << EOF
# Enabling capability mode for Zsh
if [ -n "\$ZSH_VERSION" ]; then
    setopt SH_WORD_SPLIT
fi

EOF

# --- Finding repository dir ---
. "$MODULES/escaping.sh"
cat >> "$CONFIG" << EOF
# Working Directory
DIR="$(shell_escape_quote "$DIR")"
MODULES="\$DIR/modules"

EOF

. "$MODULES/os-info.sh"

cat >> "$CONFIG" << EOF
# System Stats
OS_NAME='$OS_NAME'
EOF

if [ -n "$LINUX_FAMILY_BRANCH" ]; then
    printf '%s\n' "LINUX_FAMILY_BRANCH='$LINUX_FAMILY_BRANCH'" >> "$CONFIG"
fi

printf '%s\n' "OS_ICON='$OS_ICON'" >> "$CONFIG"

case "$OS_COLOR_RGB" in
    ''|[!0-9]*) printf "OS_COLOR_RGB='%s'\n" "$OS_COLOR_RGB" >> "$CONFIG";;
    *)                 printf "OS_COLOR_RGB=%s\n"   "$OS_COLOR_RGB" >> "$CONFIG";;
esac
case "$OS_COLOR_XTERM" in
    ''|[!0-9]*) printf "OS_COLOR_XTERM='%s'\n" "$OS_COLOR_XTERM" >> "$CONFIG";;
    *)                 printf "OS_COLOR_XTERM=%s\n"   "$OS_COLOR_XTERM" >> "$CONFIG";;
esac
case "$OS_COLOR_BASE16" in
    ''|[!0-9]*) printf "OS_COLOR_BASE16='%s'\n" "$OS_COLOR_BASE16" >> "$CONFIG";;
    *)                 printf "OS_COLOR_BASE16=%s\n"   "$OS_COLOR_BASE16" >> "$CONFIG";;
esac

printf '\n' >> "$CONFIG"

# --- Choosing What To Install ---
confs=""
deps=""
optdeps=""
dep_output=""

. "$MODULES/colors.sh"
. "$MODULES/deps.sh"

# Usage:
#   check_for_config [-n] CONFIG
# Description:
#   Checks to install a config
# Options:
#   -n  Do not add dep to $deps
check_for_config() {
    add_as_dep=1
    case "$1" in (-n)
        add_as_dep=0
        shift;;
    esac

    present=0
    if dep_present "$1"; then
        present=1
    fi
    case " $deps $optdeps " in
        *" $1 "*) present=1;;
    esac

    if [ $present -eq 1 ]; then
        while true; do
            printf "Install config for ${LIGHT_GREEN}%s${RESET}? [${BOLD}Y${RESET}/n] " "$1"
            read responce
            case "$responce" in
                [Yy]|'')
                    confs="$confs $1"

                    [ "$add_as_dep" -eq 1 ] && add_dep "$1"
                    return 0;;
                [Nn]) return 1;;
            esac
        done
    else
        while true; do
            printf "Install config for ${LIGHT_RED}%s${RESET}? [y/${BOLD}N${RESET}] " "$1"
            read responce
            case "$responce" in
                [Nn]|'') return 1;;
                [Yy])
                    confs="$confs $1"

                    [ "$add_as_dep" -eq 1 ] && add_dep "$1"
                    return 0;;
            esac
        done
    fi
}

check_for_config    hyprland && add_opt_dep uwsm kitty thunar nwg-drawer firefox mako vim gnome-calculator flameshot waybar wl-clipboard hyprpicker swaybg
check_for_config    zsh      && add_opt_dep jq
check_for_config    waybar   || :
check_for_config    mako     || :
check_for_config    kitty    || :
check_for_config -n vim      && add_dep gvim
check_for_config    cava     || :
check_for_config    mintty   || :
check_for_config    gdb      || :
check_for_config    rofi     || :

# Removing trailing spaces
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

# --- Printing dependencies ---
printf 'Dependencies: %b\n' "$dep_output"
