#!/usr/bin/env sh

# --- Showing help if --help was entered ---
case "$1" in (-h|--h|--he|--hel|--help)
    ESC="$(printf '\033')"
    BOLD="$ESC[1m"
    RESET="$ESC[0m"

cat << EOF
Usage: $0 [OPTION]...
Install LolPopGames' dotfiles

  ${BOLD}-h, --help${RESET}
         display this help and exit

The script requires config.sh file can be generated with setup.sh

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit;;
esac

# --- Loading Config ---
CONFIG="$(readlink -m "$(dirname "$0")")/config.sh"
if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
cat >&2 << EOF
config.sh: No such file or directory
Generate config.sh with setup.sh.
EOF
    exit 1
fi

# --- Not Same Link Function ---
# Usage:
#   not_same_link "file" "file"
# Description:
#   Check if two files are same with expanding symlinks
not_same_link() {
    [ "$(readlink -m "$1")" != "$(readlink -m "$2")" ]
}

# --- Link It Function ---
# Usage:
#   link_it "link-name" "target"
# Description:
#   Similar to ln, but removes symlink location file to always create a symlink
link_it() {
    if not_same_link "$1" "$2"; then
        rm -rf "$1"
        ln -s "$2" "$1"
    fi
}

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
NEW_DIR="$CONFHOME/dotfiles"

mkdir -p "$DIR"

# --- Moving repository to $NEW_DIR ---
if not_same_link "$DIR" "$NEW_DIR"; then
    mv "$DIR" "$NEW_DIR"
    ln -s "$NEW_DIR" "$DIR"
fi
link_it "$DIR/config.sh" "$NEW_DIR/config.sh"

# --- Changing $DIR in config.sh ---
. "$MODULES/escaping.sh"
sed -i "s/^DIR=.*\"/DIR=\"$(sed_sreplace_escape "$(shell_escape_quote "$NEW_DIR")")\"/" "$DIR/config.sh"

# --- Linking main things ---
link_it "$DIR/modules" "$DIR/modules"
link_it "$DIR/config.sh" "$DIR/config.sh"

# --- Installing Configurations ---
. "$MODULES/deps.sh"
for conf in $CONFS; do
    case "$conf" in
        hyprland)
            link_it "$CONFHOME/hypr" "$DIR/configs/hypr"
            if dep_present uwsm; then
                link_it "$CONFHOME/uwsm" "$DIR/configs/uwsm"
            fi
            hyprctl reload >/dev/null 2>/dev/null || :;;
        zsh);; # The build script will automatically create the dir and the configs
        *) link_it "$CONFHOME/$conf" "$DIR/configs/$conf";;
    esac
done
