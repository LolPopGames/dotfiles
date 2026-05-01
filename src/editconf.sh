#!/usr/bin/env sh

if [ -n "$XDG_CONFIG_HOME" ]; then
    CONFIG_HOME="$XDG_CONFIG_HOME"
else
    CONFIG_HOME="$HOME/.config"
fi

case "$1" in
    -h|--help)
        echo -e "Usage: \033[92meditconf\033[0m \033[94m[-c CONFIG]\033[0m program"
        echo -e "Edit source files of a complex program config"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m\tCustom config filename instead of \033[92mconfig.sh\033[0m"
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
    *) CONFIG="$CONFIG_HOME/dotfiles/config.sh";;
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

case "$1" in
    */*)
        start_part="${1%%/*}"
        end_part="${1#*/}"
        file="$CONFIG_HOME/dotfiles/${start_part}/src/${end_part}"

        if [ ! -f "$file" ] && [ ! -d "$file" ]; then
            echo "$0: $1: No such file or directory" 2>&1
            exit 1
        fi

        if [ -n "$VISUAL" ]; then
            exec "$VISUAL" "$file"
        elif [ -n "$EDITOR" ]; then
            exec "$EDITOR" "$file"
        elif command -v vim >/dev/null 2>&1; then
            exec vim "$file"
        elif command -v vi >/dev/null 2>&1; then
            exec vi "$file"
        elif command -v nano >/dev/null 2>&1; then
            exec nano "$file"
        elif command -v ed >/dev/null 2>&1; then
            exec ed "$file"
        else
            echo "$0: Failed to found any editor" 2>&1
            exit 1
        fi
        ;;

    '')
        cd "$CONFIG_HOME/dotfiles" || exit $?
        exec $SHELL --login
        ;;

    *)
        cd "$CONFIG_HOME/dotfiles/$1/src" || exit $?
        exec $SHELL --login
        ;;
esac
