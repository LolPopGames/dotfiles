#!/usr/bin/env sh

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

if [ "$1" = '--help' ]; then
    printf "Edits source files of a complex LolPopGames' config\n\n"
    printf "List configs:\n"
    for dir in "$CONFHOME/dotfiles/"*; do
        base="$(basename "$dir")"
        if [ ! -d "$dir" ] || [ "$base" = 'repo' ]; then
            continue
        fi
        printf "    $base\n"
    done
fi

CONFIG="$CONFHOME/dotfiles/config.sh"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0")/repo/setup.sh"
    printf '%s: File not found\n' "$CONFIG" >&2
    printf 'Generate %s with %s\n' "$CONFIG" "$SETUP"
    exit 1
fi

case "$1" in
    */*)
        start_part="${1%%/*}"
        end_part="${1#*/}"
        file="$CONFHOME/dotfiles/${start_part}/configs/${end_part}"

        if [ ! -f "$file" ] && [ ! -d "$file" ]; then
            echo "$0: $1: No such file or directory" 2>&1
            exit 1
        fi

        if [ -n "$VISUAL" ]; then
            "$VISUAL" "$file"
        elif [ -n "$EDITOR" ]; then
            "$EDITOR" "$file"
        elif command -v vim >/dev/null 2>&1; then
            vim "$file"
        elif command -v vi >/dev/null 2>&1; then
            vi "$file"
        elif command -v nano >/dev/null 2>&1; then
            nano "$file"
        elif command -v ed >/dev/null 2>&1; then
            ed "$file"
        else
            echo "$0: Failed to found any editor" 2>&1
            exit 1
        fi
        ;;

    '')
        cd "$CONFHOME/dotfiles" || exit $?
        exec $SHELL --login
        ;;

    *)
        cd "$CONFHOME/dotfiles/$1/src" || exit $?
        exec $SHELL --login
        ;;
esac
