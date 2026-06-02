#!/usr/bin/env sh

if [ "$1" = '--help' ]; then
    printf "Builds a complex LolPopGames' config\n\n"
    printf "List configs:\n"
    for dir in "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/"*; do
        base="$(basename "$dir")"
        if [ ! -d "$dir" ] || [ "$base" = 'repo' ]; then
            continue
        fi
        printf "    $base\n"
    done
fi

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0")/repo/setup.sh"
    printf '%s: File not found\n' "$CONFIG" >&2
    printf 'Generate %s with %s\n' "$CONFIG" "$SETUP"
    exit 1
fi

while [ "$#" -gt 0 ]; do
    if [ "$1" = "all" ]; then
        for dir in "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/"*; do
            base="$(basename "$dir")"
            if [ ! -d "$dir" ] || [ "$base" = 'repo' ]; then
                continue
            fi
            "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/$dir/build.sh"
        done

        shift
        continue
    fi
    if [ -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/$1/build.sh" ]; then
        "${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/$1/build.sh"
    else
        printf "Unknown config specified: $1\n" >&2
    fi
    shift
done
