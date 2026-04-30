#!/usr/bin/env sh

# --- Opening Config ---
case "$1" in
    -h|--help)
        echo -e "Usage: \033[92m$0\033[0m \033[94m[-o OUTPUT]\033[0m"
        echo -e "Generate configuration for \033[96mLolPopGames'\033[0m dotfiles"
        echo
        echo    "Options:"
        echo -e "    \033[94m-o OUTPUT\033[0m  generate a config with custom filename instead of \033[92mconfig.sh\033[0m"

        exit 0
        ;;
    -o) CONFIG="$2";;
    *)  CONFIG="config.sh";;
esac

# --- Getting Project Directory ---
DIR="$(realpath $(dirname "$0"))"
cd "$DIR" || exit 1

echo "DIR=$DIR" > "$CONFIG"

# -- Determining OS --
os_name=$(uname -s)

case "$os_name" in
    # --- Linux ---
    Linux*)
        # --- Android ---
        if [ "$(uname -o)" = Android* ]; then 
            if [ -n "$TERMUX_VERSION" ]; then
                OS_NAME=android-termux
            elif [ -n "$ANDROID_PROPERTY_WORKSPACE" ]; then
                OS_NAME=android-adb
            else
                OS_NAME=android
            fi

        # --- Linux ---
        else
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                OS_NAME="linux-$ID"
            else
                OS_NAME=linux-unknown
            fi
            echo "LINUX_ID_LIKE=\"$ID_LIKE\"" >> "$CONFIG"
        fi
        ;;

    # --- MacOS ---
    Darwin*) OS_NAME=macos;;

    # --- Windows (Msys2/Git Bash) ---
    CYGWIN*)      OS_NAME=windows-cygwin;;
    MSYSTEM*)     OS_NAME=windows-msys2;;
    MSYS*|MINGW*) OS_NAME=windows-gitbash;;

    # --- Other ---
    *) OS_NAME=unknown;;
esac
echo "OS_NAME=$OS_NAME" >> "$CONFIG" 

# --- Determining What Configs To Install ---
confs=()
deps=()
function check-for-config() {
    if command -v "$1" >/dev/null 2>&1; then
        while true; do
            echo -en "Install config for \033[92m$1\033[0m? [Y/n] "
            read responce
            case "$responce" in
                [Yy]|'') confs+=("$1") deps+=("$1"); return 0;;
                [Nn])                                return 1;;
            esac
        done
    else
        while true; do
            echo -en "Install config for \033[91m$1\033[0m? [y/N] "
            read responce
            case "$responce" in
                [Nn]|'')                          return 1;;
                [Yy]) confs+=("$1") deps+=("$1"); return 0;;
            esac
        done
    fi
}

check-for-config kitty
check-for-config zsh
check-for-config vim
check-for-config hyprland
check-for-config mako
check-for-config waybar
check-for-config cava
check-for-config mintty
check-for-config gdb

echo "CONFS=(${confs[@]})" >> "$CONFIG"
echo "DEPS=(${deps[@]})"   >> "$CONFIG"

echo -n 'Dependencies:'
for dep in ${deps[@]}; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo -en " \033[32m$dep\033[0m"
    else
        echo -en " \033[31m$dep\033[0m"
    fi
done
echo
