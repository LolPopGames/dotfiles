#!/usr/bin/env sh

if [ -n "$XDG_CONFIG_HOME" ]; then
    CONFIG_HOME="$XDG_CONFIG_HOME"
else
    CONFIG_HOME="$HOME/.config"
fi

case "$1" in
    -h|--help)
        echo -e "Usage: \033[92mbuildconf\033[0m \033[94m[-c CONFIG]\033[0m \033[1mprogram\033[0m"
        echo -e "Build a complex config for a program"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m  Custom config filename instead of \033[92mconfig.sh\033[0m"
        echo
        echo "List configs:"
        for dir in "$CONFIG_HOME/dotfiles/"*; do
            base="$(basename "$dir")"
            if [ ! -d "$dir" ] || [ "$base" = 'repo' ]; then
                continue
            fi
            echo "    $base"
        done

        exit 0
        ;;
    -c)
        if [ "$(expr "$2" : '\(.\)')" = '/' ]; then
            CONFIG="$2"
        else
            CONFIG="./$2"
        fi
        shift
        shift
        ;;
    *)  CONFIG="$(dirname "$0")/config.sh";;
esac

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0" | tr -d $'\n')/../setup.sh"
    echo     "$CONFIG: File not found" >&2
    echo -en "Generate \033[92m$CONFIG\033[0m with \033[92m$SETUP"
    if [ "$(basename "$CONFIG")" != 'config.sh' ]; then
        echo -e " -o $CONFIG\033[0m"
    else
        echo -e "\033[0m"
    fi
    exit 1
fi

while [ "$#" -gt 0 ]; do
    if [ -f "$CONFIG_HOME/dotfiles/$1/build.sh" ]; then
        "$CONFIG_HOME/dotfiles/$1/build.sh"
    else
        echo "Unknown config specified: $1" >&2
    fi
    shift
done
