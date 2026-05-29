#!/usr/bin/env sh

# Showing help if --help was entered
if [ "$1" = "--help" ]; then
    printf "Installs LolPopGames' dotfiles\n"
    exit 0
fi

CONFIG="config.sh"

# --- Loading Config ---
if [ -f "$CONFIG" ]; then
    . "./$CONFIG"
else
    SETUP="$(dirname "$0")/setup.sh"
    printf '%s: File not found\n' "$CONFIG" >&2
    printf 'Generate %s with %s\n' "$CONFIG" "$SETUP"
    exit 1
fi

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
. "$MODULES/deps.sh"

if [ "$INSTALL_REPO" -eq 1 ]; then
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
    DOT="$CONFHOME/dotfiles"
    # ~/.config/dotfiles/repo
    NEW_REPO="$DOT/repo"

    mkdir -p "$DOT"

    # --- Moving repository to $NEW_REPO ---
    if not-same-link "$REPO" "$NEW_REPO"; then
        mv "$REPO" "$NEW_REPO"
        ln -s "$NEW_REPO" "$REPO"
    fi
    link-it "$REPO/config.sh" "$NEW_REPO/config.sh"

    # --- Changing $DIR in config.sh ---
    . "$MODULES/escaping.sh"
    sed -i "s/^DIR=\"[^\"]*\"/DIR=\"$(sed_sreplace_escape "$(shell_escape_quote "$NEW_REPO")")\"/" "$REPO/config.sh"

    # --- Linking all *.sh scripts to ~/.config/dotfiles ---
    for script in "$REPO"/scripts/*.sh; do
        script_basename="$(basename "$script")"
        rm -rf "$DOT/$script_basename"
        ln -f -s "$script" "$DOT/$script_basename"
    done

    # --- Installing Configurations ---
    for conf in $CONFS; do
        case "$conf" in
            hyprland)
                link-it "$CONFHOME/hypr" "$REPO/configs/hypr"
                if dep_present uwsm; then
                    link-it "$CONFHOME/uwsm" "$REPO/configs/uwsm"
                fi
                hyprctl reload >/dev/null 2>/dev/null;;
            zsh) link-it "$DOT/$conf" "$REPO/configs/$conf";;
            *) link-it "$CONFHOME/$conf" "$REPO/configs/$conf";;
        esac
    done

    exit 0
else
    # --- Installing Configurations ---
    for conf in $CONFS; do
        case "$conf" in
            hyprland)
                mkdir -p "$CONFHOME/hypr"
                cp -rf "$REPO/configs/hypr/"* "$CONFHOME/hypr"
                if dep_present uwsm; then
                    rm -rf "$CONFHOME/uwsm" && cp -rf "$REPO/configs/uwsm" "$CONFHOME/uwsm"
                fi
                hyprctl reload >/dev/null 2>/dev/null;;
            zsh) rm -rf "$CONFHOME/$conf/build" && mkdir -p "$CONFHOME/$conf" && cp -rf "$REPO/configs/$conf" "$CONFHOME/$conf/build";;
            *) rm -rf "$CONFHOME/$conf" && cp -rf "$REPO/configs/$conf" "$CONFHOME/$conf";;
        esac
    done

    exit 0
fi
