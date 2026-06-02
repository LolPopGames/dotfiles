#!/usr/bin/env sh

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

if [ "$1" = '--help' ]; then
    printf "Edits build file of a complex LolPopGames' config\n\n"
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


FILE="$CONFIG_HOME/dotfiles/$1/build.sh"
if [ -n "$VISUAL" ]; then
    exec "$VISUAL" "$FILE"
elif [ -n "$EDITOR" ]; then
    exec "$EDITOR" "$FILE"
elif command -v vim >/dev/null 2>&1; then
    exec vim "$FILE"
elif command -v vi >/dev/null 2>&1; then
    exec vi "$FILE"
elif command -v nano >/dev/null 2>&1; then
    exec nano "$FILE"
elif command -v ed >/dev/null 2>&1; then
    exec ed "$FILE"
else
    echo "$0: Failed to found any editor" 2>&1
    exit 1
fi
