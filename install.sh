#!/usr/bin/env sh

# --- Parsing Arguments ---
case "$1" in
    -h|--help)
        echo -e "Usage: \033[92m$0\033[0m \033[94m[-c CONFIG]\033[0m"
        echo -e "Install \033[96mLolPopGames'\033[0m dotfiles"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m\tInstall deps with custom config filename instead of \033[92mconfig.sh\033[0m"

        exit 0
        ;;
    -c)
        if [ "$(expr "$2" : '\(.\)')" = '/' ]; then
            CONFIG="$2"
        else
            CONFIG="./$2"
        fi
        ;;
    *) CONFIG="$(realpath $(dirname "$0"))/config.sh";;
esac

# --- Loading Config ---
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

# --- Determing Config Dir ---
if [ -n "$XDG_CONFIG_HOME" ]; then
    CONFIG_HOME="$XDG_CONFIG_HOME"
else
    CONFIG_HOME="$HOME/.config"
fi

# --- Not Same Link Function ---
# Cheks if two files are same with expanding symlinks
not-same-link() {
    [ "$(readlink -f "$1")" != "$(readlink -f "$2")" ]
}

# --- Link It Function ---
# Similar to ln, but removes symlink location file to always create a symlink
link-it() {
    if not-same-link "$1" "$2"; then
        rm -rf "$1"
        ln -s "$2" "$1"
    fi
}

# ~/.config/dotfiles
DOT="$CONFIG_HOME/dotfiles"
# ~/.config/dotfiles/repo
REPO="$DOT/repo"

mkdir -p "$DOT"

# --- Moving repository to $REPO ---
if not-same-link "$DIR" "$REPO"; then
    mv "$DIR" "$REPO"
    ln -s "$REPO" "$DIR"
fi
link-it "$DOT/config.sh" "$REPO/config.sh"

# --- Changing $DIR in config.sh ---
sed -i 's|DIR="[^"]*"|DIR="'"$(echo -E "$REPO" | sed 's/[\/&|]/\\&/g')"'"|' "$REPO/config.sh"

# --- Linking all *.sh scripts in ~/.config/dotfiles ---
for script in "$REPO"/src/*.sh; do
    script_basename="$(basename "$script")"
    rm -rf "$DOT/$script_basename"
    ln -f -s "$script" "$DOT/$script_basename"
done

# --- Installing Configurations ---
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
