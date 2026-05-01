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

not-same-link() {
    [ "$(readlink -f "$1")" != "$(readlink -f "$2")" ]
}

link-it() {
    if not-same-link "$1" "$2"; then
        rm -rf "$1"
        ln -s "$2" "$1"
        return 0
    fi
    return 1
}

DOT="$CONFIG_HOME/dotfiles"
REPO="$DOT/repo"

mkdir -p "$DOT"

if not-same-link "$DIR" "$REPO"; then
    mv "$DIR" "$REPO"
    ln -s "$REPO" "$DIR"
fi
link-it "$DOT/config.sh" "$REPO/config.sh"

sed -i 's|DIR="[^"]*"|DIR="'"$(echo -E "$REPO" | sed 's/[\/&|]/\\&/g')"'"|' "$REPO/config.sh"

for script in "$REPO"/src/*.sh; do
    script_basename="$(basename "$script")"
    rm -rf "$DOT/$script_basename"
    ln -f -s "$script" "$DOT/$script_basename"
done

for conf in ${CONFS[@]}; do
    case "$conf" in
        mako|waybar|gdb|kitty|cava|vim) link-it "$CONFIG_HOME/$conf" "$REPO/src/$conf";;
        hyprland)
            link-it "$CONFIG_HOME/hypr" "$REPO/src/hypr"
            hyprctl reload >/dev/null 2>/dev/null
            link-it "$CONFIG_HOME/uwsm" "$REPO/src/uwsm"
            ;;
        zsh) link-it "$DOT/$conf" "$REPO/src/$conf";;
    esac
done

exit 0
