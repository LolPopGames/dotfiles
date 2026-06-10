#!/usr/bin/env sh
# Preloaded for Install Deps Module
if [ -z "$_install_deps_preloaded_sh__included" ]; then
_install_deps_preloaded_sh__included=1

# --- Parsing Arguments ---
display_help() {
cat << EOF
Usage: $0 [OPTION]...
Install dependencies for ${LIGHT_CYAN}LolPopGames'${RESET} dotfiles

  ${BOLD}-y, --fetch${RESET}
         fetch (refresh/update) package databases before installation

  ${BOLD}-u, --upgrade${RESET}
         upgrade all packages before installation

  ${BOLD}-n, --no-optional${RESET}
         do not install optional dependencies

  ${BOLD}-p, --print-deps${RESET}
         print dependencies and exit

  ${BOLD}-h, --help${RESET}
         display this help and exit

  ${BOLD}-v, --version${RESET}
         output version information and exit

The script requires ${LIGHT_GREEN}config.sh${RESET} file that can be generated with ${LIGHT_GREEN}setup.sh${RESET}

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit
}

# Empty mean 0, 1 mean 1
OPTIONAL=1
FETCH=
UPGRADE=
PRINT_DEPS=
find_long_option() {
    case "$1" in
        --h|--he|--hel|--help) display_help;;
        --v|--ve|--ver|--vers|--versi|--versio|--version) display_version;;
        --f|--fe|--fet|--fetc|--fetch) FETCH=1;;
        --u|--up|--upg|--upgr|--upgra|--upgrad|--upgrade) UPGRADE=1;;
        --n|--no|--no-|--no-o|--no-op|--no-opt|--no-opti|--no-optio|--no-option|--no-optiona|--no-optional) OPTIONAL=;;
        --p|--pr|--pri|--prin|--print|--print-|--print-d|--print-de|--print-dep|--print-deps) PRINT_DEPS=1;;
        --*) return 1;;
    esac
}
find_option() {
    case "$str" in
        h*) display_help;;
        v*) display_version;;
        y*) FETCH=1;;
        u*) UPGRADE=1;;
        n*) OPTIONAL=;;
        *) return 1;;
    esac
}

parse_args "$@"
load_config && {
    deps_to_install=""

    if [ -z "$PRINT_DEPS" ]; then
        printf "$DEPS\n$OPTDEPS"
    else
        for dep in $DEPS ${OPTIONAL:+$OPTDEPS}; do
            if ! dep_present "$dep"; then
                deps_to_install="$deps_to_install $dep"
            fi
        done

        deps_to_install="${deps_to_install# }"
        install_deps ${FETCH:+-y} ${UPGRADE:+-u} $deps_to_install
    fi
}

fi
