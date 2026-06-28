#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/modules/preloaded/preloaded.sh"
ask_for_config cava gdb mako rofi vim mintty
output_deps
