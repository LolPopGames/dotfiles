#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/../../modules/preloaded/preloaded.sh"
link_it "$CONFHOME/gdb" "$DIR"
