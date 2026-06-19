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
        p*) PRINT_DEPS=1;;
        *) return 1;;
    esac
}

parse_args "$@"

# --- Install Deps Function ---
# Usage:
#   install_deps [-yu] [DEP]...
# Description:
#   Cross-platform install function
# Options:
#   -y  Fetch package database
#   -u  Upgrade packages
install_deps() {
    # --- Parsing Arguments ---
    _install_deps__fetch=0
    _install_deps__upgrade=0
    while true; do
        # Breaking on -- or if not an option
        case "$1" in (--) break;; (-*);; (*) break;; esac

        # Parsing every character
        _install_deps__str="${1#-}"
        while [ -n "$_install_deps__str" ]; do
            case "$_install_deps__str" in
                y*) _install_deps__fetch=1;;
                u*) _install_deps__upgrade=1;;
            esac

            _install_deps__str="${_install_deps__str#?}"
        done
        shift
    done

    # --- Adding Dependency Functions ---
    _install_deps__default__add_dep() {
        _install_deps__deps="$_install_deps__deps $1"
    }

    _install_deps__linux_debian__add_dep() {
        case "$1" in
            gvim) _install_deps__deps="$_install_deps__deps vim-gtk3";;
            *)    _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    _install_deps__linux_ubuntu__add_dep() {
        _install_deps__linux_debian__add_dep "$@"
    }
    
    _install_deps__linux_rhel__add_dep() {
        case "$1" in
            gvim) _install_deps__deps="$_install_deps__deps vim-x11";;
            *)    _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    _install_deps__linux_gentoo__add_dep() {
        case "$1" in
            hyprland)                        _install_deps__deps="$_install_deps__deps gui-wm/$1";;
            kitty)                           _install_deps__deps="$_install_deps__deps x11-terms/$1";;
            rofi)                            _install_deps__deps="$_install_deps__deps x11-misc/$1";;
            thunar)                          _install_deps__deps="$_install_deps__deps xfce-base/$1";;
            firefox)                         _install_deps__deps="$_install_deps__deps www-client/$1";;
            mako|waybar|wl-clipboard|swaybg) _install_deps__deps="$_install_deps__deps gui-apps/$1";;
            gvim)                            _install_deps__deps="$_install_deps__deps app-editors/vim";;
            dash)                            _install_deps__deps="$_install_deps__deps app-shells/$1";;
            jq)                              _install_deps__deps="$_install_deps__deps app-misc/$1";;
            gnome-calculator)                _install_deps__deps="$_install_deps__deps gnome-extra/$1";;
            flameshot)                       _install_deps__deps="$_install_deps__deps media-gfx/$1";;
            cava)                            _install_deps__deps="$_install_deps__deps media-sound/$1";;
            gdb)                             _install_deps__deps="$_install_deps__deps dev-debug/$1";;
            hyprpicker|nwg-drawer)           _install_deps__deps2="$_install_deps__deps2 gui-apps/$1";;
            *)                               _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    _install_deps__linux_nixos__add_dep() {
        case "$1" in
            thunar)   _install_deps__deps="$_install_deps__deps nixpkgs.xfce.$1";;
            firefox)  _install_deps__deps="$_install_deps__deps nixpkgs.firefox-bin";;
            *)        _install_deps__deps="$_install_deps__deps nixpkgs.$1";;
        esac
    }

    _install_deps__macos__add_dep() {
        case "$1" in
            gvim) _install_deps__deps="$_install_deps__deps vim";;
            hyprland|waybar|mako|thunar|nwg-drawer|gnome-calculator|hyprpicker|swaybg|uwsm);;
            *)    _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    _install_deps__android_termux__add_dep() {
        case "$1" in
            gvim) _install_deps__deps="$_install_deps__deps vim";;
            *)    _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    _install_deps__windows_msys2__add_dep() {
        case "$1" in
            gvim) _install_deps__deps="$_install_deps__deps vim";;
            hyprland|waybar|mako|kitty|rofi|uwsm|thunar|nwg-drawer|firefox|gnome-calculator|flameshot|wl-clipboard|hyprpicker|swaybg);;
            *)    _install_deps__deps="$_install_deps__deps $1";;
        esac
    }

    if [ "$OS_NAME" = 'windows-cygwin' ] && dep_present apt-cyg; then
        _install_deps__aptcyg_exists=1
    else
        _install_deps__aptcyg_exists=0
    fi
    _install_deps__windows_cygwin__add_dep() {
        if [ "$install_deps__aptcyg_exists" -eq 1 ]; then
            case "$1" in
                gvim) _install_deps__deps="$_install_deps__deps vim";;
                hyprland|waybar|mako|kitty|rofi|uwsm|thunar|nwg-drawer|firefox|flameshot|wl-clipboard|hyprpicker|swaybg|cava);;
                *)    _install_deps__deps="$_install_deps__deps $1";;
            esac
        else
            case "$1" in
                gvim) _install_deps__deps="$_install_deps__deps,vim";;
                hyprland|waybar|mako|kitty|rofi|uwsm|thunar|nwg-drawer|firefox|flameshot|wl-clipboard|hyprpicker|swaybg|cava);;
                *)    _install_deps__deps="$_install_deps__deps,$1";;
            esac
        fi
    }

    # --- Getting deps to install ---
    _install_deps__deps=
    _install_deps__deps2= # 2nd installation method

    # Getting add_dep command
    _install_deps__add_dep="_install_deps__$(printf "$OS_NAME" | sed 's/-/_/g')__add_dep"
    if ! dep_present "$_install_deps__add_dep"; then
        _install_deps__add_dep='_install_deps__default__add_dep'
    fi

    for _install_deps__dep in "$@"; do
        if ! dep_present "$_install_deps__dep"; then
            "$_install_deps__add_dep" "$_install_deps__dep"
        fi
    done

    # Removing trailing whitespace
    _install_deps__deps="${_install_deps__deps#?}"
    _install_deps__deps2="${_install_deps__deps2#?}"

    # --- Checking if there is any dependency ---
    if [ -z "$_install_deps__deps" ] && [ -z "$_install_deps__deps2" ]; then
        printf 'There is nothing to do.\n'
        return 0
    fi

    # --- Determining the system ---
    case "$OS_NAME" in
        linux-*) # --- Linux ---
            case "$LINUX_FAMILY_BRANCH" in
                arch)
                    if   [ "$_install_deps__fetch" -eq 1 ] && [ "$_install_deps__upgrade" -eq 1 ]; then
                        sudo pacman -Syu --color=auto --needed $_install_deps__deps
                    elif [ "$_install_deps__fetch" -eq 1 ]; then
                        sudo pacman -Sy  --color=auto --needed $_install_deps__deps
                    elif [ "$_install_deps__upgrade" -eq 1 ]; then
                        sudo pacman -Su  --color=auto --needed $_install_deps__deps
                    else
                        sudo pacman -S   --color=auto --needed $_install_deps__deps
                    fi;;

                debian|ubuntu)
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo apt update
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo apt upgrade
                    sudo apt install $_install_deps__deps;;

                rhel)
                    if   [ "$_install_deps__upgrade" -eq 1 ]; then
                        sudo dnf upgrade
                    elif [ "$_install_deps__install" -eq 1 ]; then
                        sudo dnf makecache
                    fi
                    sudo dnf install $_install_deps__deps;;

                opensuse)
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo zypper refresh
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo zypper upgrade
                    sudo zypper install $_install_deps__deps;;

                gentoo)
                    # --- Checking for GURU install method ---
                    if [ -n "$_install_deps__deps2" ]; then
                        # --- Checking GURU state ---
                        if ! eselect repository list | grep -Eq '^[[:space:]]*[0-9]+[[:space:]]+guru[[:space:]]'; then
                            _install_deps__guru_state=not-added
                        elif eselect repository list -i | grep -q '^guru$'; then
                            _install_deps__guru_state=enabled
                        else
                            _install_deps__guru_state=disabled
                        fi

                        # --- Asking for enabling GURU ---
                        if [ "$_install_deps__guru_state" != enabled ]; then
                            . "$MODULES/colors.sh"
                            _install_deps__deps_colored=
                            for _install_deps__dep in $_install_deps__deps2; do
                                if dep_present "$_install_deps__dep"; then
                                    _install_deps__deps_colored="$_install_deps__deps_colored, ${LIGHTGREEN}$_install_deps__dep${RESET}"
                                else
                                    _install_deps__deps_colored="$_install_deps__deps_colored, ${LIGHTRED}$_install_deps__dep${RESET}"
                                fi
                            done
                            # Removing trailing separator
                            _install_deps__deps_colored="${_install_deps__deps_colored#, }"
                            # Replacing last separator with "and" if needed
                            case "$install_deps__deps_colored" in (', ')
                                _install_deps__deps_colored="${_install_deps__deps_colored%, *}"
                                if dep_present "$_install_deps__dep"; then
                                    _install_deps__deps_colored="$_install_deps__deps_colored and ${LIGHTGREEN}$_install_deps__dep${RESET}"
                                else
                                    _install_deps__deps_colored="$_install_deps__deps_colored and ${LIGHTRED}$_install_deps__dep${RESET}"
                                fi;;
                            esac

                            # Getting answer
                            if [ "$_install_deps__guru_state" = not-added ]; then
                                _install_deps__text="%s depends on GURU overlay. Add it? (Y/n) "
                            else
                                _install_deps__text="%s depends on GURU overlay. Enable it? (Y/n) "
                            fi
                            while true; do
                                printf "$_install_deps__text" "$_install_deps__deps_colored"
                                read _install_deps__responce
                                case "$_install_deps__responce" in
                                    [Yy]|'')
                                        if [ "$_install_deps__guru_state" = not-added ]; then
                                            sudo eselect repository add guru git 'https://github.com/gentoo-mirror/guru.git'
                                        fi

                                        sudo eselect repository enable guru
                                        if [ "$_install_deps__fetch" -eq 0 ]; then
                                            sudo emaint sync -r guru
                                        fi

                                        _install_deps__deps="${_install_deps__deps:+"$install_deps__deps "}$install_deps__deps2"

                                        break;;
                                    [Nn]) break;;
                                esac
                            done
                        fi
                    fi

                    # --- Installing Deps ---
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo emaint sync --auto
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo emerge -uDN @world
                    sudo emerge -a $_install_deps__deps;;
                
                alpine)
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo apk update
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo apk upgrade
                    sudo apk add $_install_deps__deps;;

                clear-linux-os)
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo swupd update
                    sudo swupd builde-add $_install_deps__deps;;
                
                solus)
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo eopkg update-repo
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo eopkg upgrade
                    sudo eopkg install $_install_deps__deps;;
                
                void)
                    if [ "$_install_deps__fetch" -eq 1 ] && [ "$install_deps__upgrade" -eq 1 ]; then
                        sudo xbps-install -Su
                    elif [ "$_install_deps__upgrade" -eq 1 ]; then
                        sudo xbps-install -u
                    fi

                    if [ "$_install_deps__fetch" -eq 1 ] && [ "$_install_deps__upgrade" -ne 1 ]; then
                        sudo xbps-install -S $_install_deps__deps
                    else
                        sudo xbps-install $_install_deps__deps
                    fi;;

                nixos)
                    [ "$_install_deps__fetch"   -eq 1 ] && nix-channel --update
                    [ "$_install_deps__upgrade" -eq 1 ] && nix-env -u
                    nix-env -iA $_install_deps__deps;;

                guix)
                    [ "$_install_deps__fetch"   -eq 1 ] && sudo guix pull
                    [ "$_install_deps__upgrade" -eq 1 ] && sudo guix package -u
                    sudo guix package -i $_install_deps__deps;;

                *)
                    printf 'Unknown how to install dependencies for this linux' >&2;;
            esac;;

        macos) # --- MacOS ---
            if ! dep_present brew; then
                printf "Homebrew is not installed\n"
                . "$MODULES/colors.sh"
                while true; do
                    printf "Install ${LIGHT_GREEN}homebrew${RESET} and ${LIGHT_GREEN}dependencies${RESET}? [Y/n] "
                    read _install_deps__responce
                    case "$_install_deps__responce" in
                        [Yy]|'') /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; break;;
                        [Nn]) return;;
                    esac
                done
            fi
            [ "$_install_deps__fetch"   -eq 1 ] && sudo brew update
            [ "$_install_deps__upgrade" -eq 1 ] && sudo brew upgrade
            sudo brew install $_install_deps__deps;;

        android-termux) # --- Android (Termux) ---
            [ "$_install_deps__upgrade" -eq 1 ] && sudo pkg upgrade
            sudo pkg install $_install_deps__deps;;

        # --- Windows ---
        windows-msys2)
            if   [ "$_install_deps__fetch" -eq 1 ] && [ "$_install_deps__upgrade" -eq 1 ]; then
                sudo pacman -Syu --needed $_install_deps__deps
            elif [ "$_install_deps__fetch" -eq 1 ]; then
                sudo pacman -Sy  --needed $_install_deps__deps
            elif [ "$_install_deps__upgrade" -eq 1 ]; then
                sudo pacman -Su  --needed $_install_deps__deps
            else
                sudo pacman -S   --needed $_install_deps__deps
            fi;;
        windows-cygwin)
            # Checking for apt-cyg
            if command -v apt-cyg >/dev/null 2>&1; then
                # --- Installing via apt-cyg ---
                [ "$_install_deps__fetch"   -eq 1 ] && sudo apt-cyg update
                [ "$_install_deps__upgrade" -eq 1 ] && sudo apt-cyg upgrade
                sudo apt-cyg install $_install_deps__deps
            else
                # --- Installing via official setup-x86_64.exe ---
                _install_deps__cache="${XDG_CACHE_HOME:-"$HOME/.cache"}/dotfiles"
                _install_deps__cygsetup="$_install_deps_cache/setup-x86_64.exe"

                curl -o "$_install_deps__cygsetup" 'https://www.cygwin.com/setup-x86_64.exe'
                if [ "$_install_deps__upgrade" -eq 1 ]; then
                    "$_install_deps__cygsetup" -q --upgrade-also -P "$_install_deps__deps" -g
                else
                    if "$_install_deps__fetch" -eq 1 ]; then
                        "$_install_deps__cygsetup" -q -D
                    fi
                    "$_install_deps__cygsetup" -q -P "$_install_deps__deps" -g
                fi

                rm -f "$_install_deps__cygsetup" && rm -df "$_install_deps__cache"
            fi;;

        *) printf 'Unknown how to install dependencies for this system' >&2;;
    esac
}

# --- Making Deps ---
load_config
deps_to_install=

if [ -n "$PRINT_DEPS" ]; then
    printf "$DEPS\n$OPTDEPS"
elif [ "${DEPS+set}" = set ] || [ "${OPTDEPS+set}" = set ]; then
    for dep in $DEPS ${OPTIONAL:+$OPTDEPS}; do
        if ! dep_present "$dep"; then
            deps_to_install="$deps_to_install $dep"
        fi
    done

    deps_to_install="${deps_to_install# }"
    install_deps ${FETCH:+-y} ${UPGRADE:+-u} $deps_to_install
fi

fi
