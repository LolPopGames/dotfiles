#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/modules/preloaded/preloaded.sh"

check_for_config    hyprland && add_opt_dep uwsm kitty thunar nwg-drawer firefox mako vim gnome-calculator flameshot waybar wl-clipboard hyprpicker swaybg
check_for_config    zsh      && add_opt_dep jq
check_for_config    waybar   || :
check_for_config    mako     || :
check_for_config    kitty    || :
check_for_config -n vim      && add_dep gvim
check_for_config    cava     || :
check_for_config    mintty   || :
check_for_config    gdb      || :
check_for_config    rofi     || :

output_deps
