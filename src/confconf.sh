#!/usr/bin/env sh

if [ -n "$XDG_CONFIG_HOME" ]; then
    CONFIG_HOME="$XDG_CONFIG_HOME"
else
    CONFIG_HOME="$HOME/.config"
fi

case "$1" in
    -h|--help)
        echo -e "Usage: \033[92mconfconf\033[0m \033[94m[-c CONFIG]\033[0m program"
        echo -e "Configure building of a complex program config"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m  Configure a complex config using custom config filename"
        echo -e                "               instead of \033[92mconfig.sh\033[0m"
        echo
        echo "List configs:"
        for dir in "$CONFIG_HOME/dotfiles/"*; do
            [ -d "$dir" ] || continue
            echo "    $(basename "$dir")"
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
    echo     "$0: $CONFIG: File not found" >&2
    echo -en "Generate \033[92m$CONFIG\033[0m with \033[92m$SETUP"
    if [ "$(basename "$CONFIG")" != 'config.sh' ]; then
        echo -e " -o $CONFIG\033[0m"
    else
        echo -e "\033[0m"
    fi
    exit 1
fi

if [ -n "$VISUAL" ]; then
    exec "$VISUAL" "$1"
elif [ -n "$EDITOR" ]; then
    exec "$EDITOR" "$1"
elif command -v vim >/dev/null 2>&1; then
    exec vim "$1"
elif command -v vi >/dev/null 2>&1; then
    exec vi "$1"
elif command -v nano >/dev/null 2>&1; then
    exec nano "$1"
elif command -v ed >/dev/null 2>&1; then
    exec ed "$1"
else
    echo "$0: Failed to found any editor" 2>&1
    exit 1
fi
