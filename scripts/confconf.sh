#!/usr/bin/env sh

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

if [ "$1" = '--help' ]; then
    printf "Configures a complex LolPopGames' config\n\n"
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

if [ -n "$VISUAL" ]; then
    exec "$VISUAL" "$CONFHOME/dotfiles/$1/config.sh"
elif [ -n "$EDITOR" ]; then
    exec "$EDITOR" "$CONFHOME/dotfiles/$1/config.sh"
elif command -v vim >/dev/null 2>&1; then
    exec vim "$CONFHOME/dotfiles/$1/config.sh"
elif command -v vi >/dev/null 2>&1; then
    exec vi "$CONFHOME/dotfiles/$1/config.sh"
elif command -v nano >/dev/null 2>&1; then
    exec nano "$CONFHOME/dotfiles/$1/config.sh"
elif command -v ed >/dev/null 2>&1; then
    exec ed "$CONFHOME/dotfiles/$1/config.sh"
else
    echo "$0: Failed to found any editor" 2>&1
    exit 1
fi
