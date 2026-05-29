#!/usr/bin/env sh

# --- Help Function --- 
# It also will automatically exit program
display_help() {
printf "Install dependencies for LolPopGames' dotfiles

Options:
    -n\tDo not install optional dependencies
    -y\tFetch (refresh/update) package databases
    -u\tUpgrade packages\n"
    exit 0
}

# --- Parsing Arguments ---
CONFIG="config.sh"
FETCH=0
UPGRADE=0
while [ "$#" -gt 0 ]; do
    # If --help
    [ "$1" = '--help' ] && display_help

    # If first character of arguments is '-' (flag)
    if [ "${1%%${1#?}}" = '-' ]; then
        # --- Parsing every letter ---
        str="$1"
        while [ -n "$str" ]; do
            case "$str" in
                h*) display_help;; # -h (--help)
                y*) FETCH=1;;      # -y
                u*) UPGRADE=1;;    # -u
            esac
            str="${str#?}"
        done
    fi
    shift
done

# --- Loading Config ---
if [ -f "$CONFIG" ]; then
    . "./$CONFIG"
else
    SETUP="$(dirname "$0")/setup.sh"
    printf '%s: File not found\n' "$CONFIG" >&2
    printf 'Generate %s with %s\n' "$CONFIG" "$SETUP"
    exit 1
fi

# --- Determining Which Dependencies to install ---
deps_to_install=""
. "$MODULES/deps.sh"

for dep in $DEPS $OPTDEPS; do
    if ! dep_present "$dep"; then
        deps_to_install="$deps_to_install $dep"
    fi
done

deps_to_install="${deps_to_install#?}"

# --- Replace Package Function ---
# Description:
#   replace_dep "dep" "new-dep-name"
# Description:
#   Replaces the dep (if exists) with new-dep-name
replace_dep() {
    deps_to_install="$(printf ' %s ' "$deps_to_install" | sed "s/ $1 / $2 /g")"
    deps_to_install="${deps_to_install#?}"
    deps_to_install="${deps_to_isntall%?}"
}

# --- Installing Dependencies ---
# Checking if where is any deps to install
if [ -n "$deps_to_install" ]; then
    case "$OS_NAME" in
        linux-*) # --- Linux ---
            case "$LINUX_FAMILY_BRANCH" in
                arch)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo pacman -Syu --color=auto --needed $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo pacman -Sy --color=auto --needed $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo pacman -Su --color=auto --needed $deps_to_install || exit $?
                    else
                        sudo pacman -S --color=auto --needed $deps_to_install || exit $?
                    fi
                    ;;

                debian|ubuntu)
                    replace_dep gvim vim-gtk3
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo apt update && sudo apt upgrade -y && sudo apt install $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo apt update && sudo apt install $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo apt upgrade -y && sudo apt install $deps_to_install || exit $?
                    else
                        sudo apt install $deps_to_install || exit $?
                    fi
                    ;;

                rhel)
                    replace_dep gvim vim-X11
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo dnf upgrade && sudo dnf install $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo dnf makecache && sudo dnf install $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo dnf upgrade && sudo dnf install $deps_to_install || exit $?
                    else
                        sudo dnf install $deps_to_install || exit $?
                    fi
                    ;;

                opensuse)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo zypper refresh && sudo zypper upgrade && sudo zypper install $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo zypper refresh && sudo zypper install $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo zypper upgrade && sudo zypper install $deps_to_install || exit $?
                    else
                        sudo zypper install $deps_to_install || exit $?
                    fi
                    ;;

                gentoo)
                    add_category() {
                        replace_dep "$1" "$1/$2"
                    }
                    remove_dep() {
                        deps_to_install="$(printf ' %s ' "$deps_to_install" | sed "s/ $1 //g")"
                        deps_to_install="${deps_to_install#?}"
                        deps_to_install="${deps_to_isntall%?}"
                    }
                    remove_dep hyprpicker
                    remove_dep nwg-drawer

                    add_category gui-wm hyprland
                    add_category x11-terms kitty
                    add_category xfce-base thunar
                    add_category www-client firefox
                    add_category gui-apps mako
                    add_category app-editors gvim
                    replace_dep app-editors/gvim app-editors/vim
                    add_category gnome-extra gnome-calculator
                    add_category media-gfx flameshot
                    add_category gui-apps waybar
                    add_category gui-apps wl-clipboard
                    add_category app-shells dash
                    add_category gui-apps swaybg
                    add_category app-shells zsh
                    add_category app-misc jq
                    add_category media-sound cava
                    add_category dev-debug gdb
                    add_category x11-misc rofi

                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo emerge --sync && sudo emerge -uDN @world && sudo emerge -a $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo emerge --sync && sudo emerge -a $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo emerge -uDN @world && sudo emerge -a $deps_to_install || exit $?
                    else
                        sudo emerge -a $deps_to_install || exit $?
                    fi
                    ;;

                alpine)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo apk update && sudo apk upgrade && sudo apk add $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo apk update && sudo apk add $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo apk upgrade && sudo apk add $deps_to_install || exit $?
                    else
                        sudo apk add $deps_to_install || exit $?
                    fi
                    ;;

                clear-linux-os)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo swupd update && sudo swupd update && sudo swupd bundle-add $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ] || [ $UPGRADE -eq 1 ]; then
                        sudo swupd update && sudo swupd bundle-add $deps_to_install || exit $?
                    else
                        sudo swupd bundle-add $deps_to_install || exit $?
                    fi
                    ;;

                solus)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo eopkg update-repo && sudo eopkg upgrade && sudo eopkg install $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo eopkg update-repo && sudo eopkg install $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo eopkg upgrade && sudo eopkg install $deps_to_install || exit $?
                    else
                        sudo eopkg install $deps_to_install || exit $?
                    fi
                    ;;

                void)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo xbps-install -S && sudo xbps-install -Su && sudo xbps-install $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo xbps-install -S && sudo xbps-install $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo xbps-install -Su && sudo xbps-install $deps_to_install || exit $?
                    else
                        sudo xbps-install $deps_to_install || exit $?
                    fi
                    ;;

                nixos)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo nix-channel --update && sudo nix-env -u && \
                            (IFS=' nixos.'; sudo nix-env -iA "$deps_to_install") || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo nix-channel --update && (IFS=' nixos.'; sudo nix-env -iA "$deps_to_install") || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo nix-env -u && (IFS=' nixos.'; sudo nix-env -iA "$deps_to_install") || exit $?
                    else
                        (IFS=' nixos.'; sudo nix-env -iA "$deps_to_install") || exit $?
                    fi
                    ;;

                guix)
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo guix pull && sudo guix package -u && sudo package -i $deps_to_install || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo guix pull && sudo package -i $deps_to_install || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo guix package -u && sudo package -i $deps_to_install || exit $?
                    else
                        sudo package -i $deps_to_install || exit $?
                    fi
                    ;;

                *) echo "Unknown how to install dependencies for this linux"; exit 1;;
            esac
            ;;

        macos) # --- MacOS ---
            if dep_present brew; then
                printf "Homebrew is not installed\n"
                . "$MODULES/colors.sh"
                while true; do
                    printf "Install ${LIGHT_GREEN}homebrew${RESET} and ${LIGHT_GREEN}dependencies${RESET}? [Y/n] "
                    read responce
                    case "$responce" in
                        [Yy]|'') /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit $?; break;;
                        [Nn]) exit 1;;
                    esac
                done
            fi
            replace_dep gvim vim
            brew update && brew install $deps_to_install || exit $?
            ;;

        # --- Android (Termux) ---
        android-termux)
            replace_dep gvim vim-gtk
            pkg install $deps_to_install || exit $?;;

        # --- Windows ---
        windows-msys2) pacman -S --needed $deps_to_install || exit $?;;
        windows-cygwin)
            # Checking for apt-cyg
            if command -v apt-cyg >/dev/null 2>&1; then
                # --- Installing via apt-cyg ---
                apt-cyg update && apt-cyg install $deps_to_install || exit $?
            else
                # --- Installing via official setup-x86_64.exe ---
                if [ -n "$XDG_CACHE_HOME" ]; then
                    CACHE="$XDG_CACHE_HOME/dotfiles"
                else
                    CACHE="$HOME/.cache/dotfiles"
                fi

                curl -o "$CACHE/setup-x86_64.exe" 'https://www.cygwin.com/setup-x86_64.exe' || exit $?
                set -- $deps_to_install
                (IFS=','; "$CACHE/setup-x86_64.exe" -q -P "$*" -g || exit $?)

                rm -f "$CACHE/setup-x86_64.exe" && rm -df "$CACHE"
            fi
            ;;

        *) echo "Unknown how to install dependencies for this system"; exit 1;;
    esac
else
    echo "There is nothing to do"
fi

exit 0
