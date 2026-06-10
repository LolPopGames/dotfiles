#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/modules/preloaded/preloaded.sh"

NEW_DIR="$CONFHOME/dotfiles"

# --- Moving repository to $NEW_DIR ---
if not_same_link "$DIR" "$NEW_DIR"; then
    mv "$DIR" "$NEW_DIR"
    ln -s "$NEW_DIR" "$DIR"

    # --- Changing $DIR in config.sh ---
    . "$MODULES/escaping.sh"
    sed -i "s/^DIR=.*\"/DIR=\"$(sed_sreplace_escape "$(shell_escape_quote "$NEW_DIR")")\"/" "$DIR/config.sh"
fi

# --- Installing Configurations ---
for conf in $CONFS; do
    "$NEW_DIR/configs/$conf/install.sh"
done
