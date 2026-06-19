#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/modules/preloaded/preloaded.sh"
ask_for_config cava gdb mako rofi vim mintty
output_deps

printf '\n'
if ask_yesno "${LIGHT_GREEN}Install${RESET} dependencies and configurations right now" y; then
    printf '==> Installing dependencies...\n'
    "$DIR/install-deps.sh"
    printf '==> Installing configurations...\n'
    "$DIR/install.sh"
fi
