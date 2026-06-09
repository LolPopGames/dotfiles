#!/usr/bin/env sh

# --- Help Function --- 
# Usage:
#   display_help
# Description:
#   Displays help and exits the program
display_help() {
    ESC="$(printf '\033')"
    BOLD="$ESC[1m"
    RESET="$ESC[0m"

cat << EOF
Usage: $0 [OPTION]...
Install dependencies for LolPopGames' dotfiles

  ${BOLD}-y, --fetch${RESET}
         fetch (refresh/update) package databases before installation

  ${BOLD}-u, --upgrade${RESET}
         upgrade all packages before installation

  ${BOLD}-n, --no-optional${RESET}
         do not install optional dependencies

  ${BOLD}-h, --help${RESET}
         display this help and exit

The script requires config.sh file can be generated with setup.sh

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository
EOF
    exit
}

# --- Config ---
CONFIG="$(readlink -m "$(dirname "$0")")/config.sh"

# --- Parsing Arguments ---
# Empty will mean 0, 1 will mean 1
OPTIONAL=1
FETCH=
UPGRADE=
while [ "$#" -gt 0 ]; do
    # Long options
    case "$1" in
        --h|--he|--hel|--help) display_help;;
        --f|--fe|--fet|--fetc|--fetch) FETCH=1;;
        --u|--up|--upg|--upgr|--upgra|--upgrad|--upgrade) UPGRADE=1;;
        --n|--no|--no-|--no-o|--no-op|--no-opt|--no-opti|--no-optio|--no-option|--no-optiona|--no-optional) OPTIONAL=;;
        --) break;; # end of options
        --*)
cat >&2 << EOF
$0: unrecognized option '$1'
Try '$0 --help' for more information.
EOF
            exit 1;;
    esac

    # If first character of arguments is '-' (flag)
    if [ "${1%%${1#?}}" = '-' ]; then
        # --- Parsing every letter ---
        str="${1#?}"
        while [ -n "$str" ]; do
            case "$str" in
                h*) display_help;;
                y*) FETCH=1;;      # -y
                u*) UPGRADE=1;;    # -u
                n*) OPTIONAL=;;
                *)
cat >&2 << EOF
$0: unrecognized option '${1%"${1#?}"}'
Try '$0 --help' for more information.
EOF
                    exit 1;;
            esac
            str="${str#?}"
        done
    fi
    shift
done

# --- Loading Config ---
if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else

cat >&2 << EOF
config.sh: No such file or directory
Generate config.sh with setup.sh.
EOF
    exit 1
fi

# --- Determining Which Dependencies To Install ---
deps_to_install=""
. "$MODULES/deps.sh"

for dep in $DEPS ${OPTIONAL:+$OPTDEPS}; do
    if ! dep_present "$dep"; then
        deps_to_install="$deps_to_install $dep"
    fi
done

deps_to_install="${deps_to_install# }"

# --- Installing Dependencies ---
install_deps ${FETCH:+-y} ${UPGRADE:+-u} $deps_to_install
