#!/usr/bin/env sh

case "$1" in
    -h|--help)
        echo -e "Usage: \033[92m$0\033[0m \033[94m[-c CONFIG]\033[0m"
        echo -e "Install \033[96mLolPopGames'\033[0m dotfiles"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m  Install deps with custom config filename instead of \033[92mconfig.sh\033[0m"

        exit 0
        ;;
    -c)
        if [ "$(expr "$2" : '\(.\)')" = '/' ]; then
            CONFIG="$2"
        else
            CONFIG="./$2"
        fi
        ;;
    *)  CONFIG="./config.sh";;
esac

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0" | tr -d $'\n')/setup.sh"
    echo     "$CONFIG: File not found" >&2
    echo -en "Generate \033[92m$CONFIG\033[0m with \033[92m$SETUP"
    if [ "$CONFIG" != './config.sh' ]; then
        echo -e " -o $CONFIG\033[0m"
    else
        echo -e "\033[0m"
    fi
    exit 1
fi

if [ -n "$XDG_CONFIG_HOME" ]; then
    CONFIG_HOME="$XDG_CONFIG_HOME"
else
    CONFIG_HOME="$HOME/.config"
fi

mkdir -p "$CONFIG_HOME/dotfiles/src"
cp "$DIR"/src/*.sh "$CONFIG_HOME/dotfiles"

for conf in ${CONFS[@]}; do
    case "$conf" in
        mako|waybar|gdb|kitty|cava|vim) cp -r "$DIR/src/$conf" "$CONFIG_HOME";;
        hyprland) cp -r "$DIR/src/hypr" "$CONFIG_HOME";;
        zsh) cp -r "$DIR/src/$conf" "$CONFIG_HOME/dotfiles";;
    esac
done
