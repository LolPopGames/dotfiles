#!/usr/bin/env sh
# Parsing Arguments Module

# Usage:
#   show_no_option OPTION
# Description:
#   Show unrecognized option error and exit
show_no_option() {
cat >&2 << EOF
$0: unrecognized option '$1'
Try '$0 --help' for more information.
EOF
    exit 1
}

# Usage:
#   parse_args "$@"
# Description:
#   Parses arguments.
#   Calls "find_long_option" and "find_option" to determine an option
parse_args() {
    while [ "$#" -gt 0 ]; do
        [ "$1" = '--' ] && break
        find_long_option "$1" || show_no_option "$1"

        # If first character of arguments is '-' (short flag)
        if [ "${1%%${1#?}}" = '-' ]; then
            # --- Parsing every letter ---
            str="${1#?}"
            while [ -n "$str" ]; do
                find_option "$1" || show_no_option "-${str%"${str#?}"}"
                str="${str#?}"
            done
        fi
        shift
    done
}
