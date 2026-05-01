#!/usr/bin/env sh

# --- Help Function --- 
# It also will automatically exit program
display-help() {
    echo -e "Usage: \033[92m$0\033[0m \033[94m[-c CONFIG]\033[0m"
    echo -e "Install dependencies for \033[96mLolPopGames'\033[0m dotfiles"
    echo
    echo    "Options:"
    echo -e "    \033[94m-c CONFIG\033[0m\tCustom config filename instead of \033[92mconfig.sh\033[0m"
    echo -e "    \033[94m-y\033[0m         Fetch (refresh/update) package databases"
    echo -e "    \033[94m-u\033[0m         Upgrade packages"

    exit 0
}

# --- Parsing Arguments ---
FETCH=0
UPGRADE=0
CONFIG="$(realpath $(dirname "$0"))/config.sh"
while [ "$#" -gt 0 ]; do
    # If --help
    [ "$1" = "--help" ] && display-help

    # If first character of arguments is '-' (flag)
    if [ "$(echo "$1" | cut -c1)" = '-' ]; then
        # --- Parsing every letter ---
        plen=$(( $(echo "$1" | wc -c) -1 ))
        i=2
        while [ "$i" -le "$plen" ]; do
            char=$(echo "$1" | cut -c"$i")
            case "$char" in
                h) display-help;; # -h (--help)
                c)                # -c
                    if [ "$(expr "$2" : '\(.\)')" = '/' ]; then
                        CONFIG="$2"
                    else
                        CONFIG="./$2"
                    fi
                    shift
                    ;;
                y) FETCH=1;;   # -y
                u) UPGRADE=1;; # -u
            esac
            i=$((i+1))
        done
    fi
    shift
done

# --- Loading Config ---
if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0" | tr -d $'\n')/setup.sh"
    echo     "$CONFIG: File not found" >&2
    echo -en "Generate \033[92m$CONFIG\033[0m with \033[92m$SETUP"
    if [ "$CONFIG" != './config.sh' ]; then
        echo -e " -o $CONFIG\033[0m"
    else
        echo -e "\033[0m"
    fi
    exit 1
fi

# --- Determining Which Dependencies to install ---
deps_to_install=()
for dep in ${DEPS[@]}; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        deps_to_install+=("$dep")
    fi
done

# --- Installing Dependencies ---
# Checking if where is any deps to install
if [ "${#deps_to_install[@]}" -gt 0 ]; then
    case "$OS_NAME" in
        linux-*) # --- Linux ---
            case "$OS_NAME $LINUX_ID_LIKE" in
                *arch*) # --- Arch Linux ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo pacman -Syu --color=auto --needed ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo pacman -Sy --color=auto --needed ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo pacman -Su --color=auto --needed ${deps_to_install[@]} || exit $?
                    else
                        sudo pacman -S --color=auto --needed ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *debian*|*ubuntu*|*pclinuxos*) # --- Ubuntu/Debian ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo apt update && sudo apt upgrade -y && sudo apt install ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo apt update && sudo apt install ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo apt upgrade -y && sudo apt install ${deps_to_install[@]} || exit $?
                    else
                        sudo apt install ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *rhel*|*fedora*) # --- Fedora ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo dnf upgrade && sudo dnf install ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo dnf makecache && sudo dnf install ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo dnf upgrade && sudo dnf install ${deps_to_install[@]} || exit $?
                    else
                        sudo dnf install ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *opensuse*|*sles*) # --- OpenSUSE ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo zypper refresh && sudo zypper upgrade && sudo zypper install ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo zypper refresh && sudo zypper install ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo zypper upgrade && sudo zypper install ${deps_to_install[@]} || exit $?
                    else
                        sudo zypper install ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *gentoo*) # --- Gentoo ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo emerge --sync && sudo emerge -uDN @world && sudo emerge -a ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo emerge --sync && sudo emerge -a ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo emerge -uDN @world && sudo emerge -a ${deps_to_install[@]} || exit $?
                    else
                        sudo emerge -a ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *alpine*) # --- Alpine ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo apk update && sudo apk upgrade && sudo apk add ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo apk update && sudo apk add ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo apk upgrade && sudo apk add ${deps_to_install[@]} || exit $?
                    else
                        sudo apk add ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *clear-linux-os*) # --- Clear Linux OS ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo swupd update && sudo swupd update && sudo swupd bundle-add ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ] || [ $UPGRADE -eq 1 ]; then
                        sudo swupd update && sudo swupd bundle-add ${deps_to_install[@]} || exit $?
                    else
                        sudo swupd bundle-add ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *solus*) # --- Solus ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo eopkg update-repo && sudo eopkg upgrade && sudo eopkg install ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo eopkg update-repo && sudo eopkg install ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo eopkg upgrade && sudo eopkg install ${deps_to_install[@]} || exit $?
                    else
                        sudo eopkg install ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *void*) # --- Void Linux ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo xbps-install -S && sudo xbps-install -Su && sudo xbps-install ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo xbps-install -S && sudo xbps-install ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo xbps-install -Su && sudo xbps-install ${deps_to_install[@]} || exit $?
                    else
                        sudo xbps-install ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *nixos*) # --- Nix ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo nix-channel --update && sudo nix-env -u && \
                            (IFS=' nixos.'; sudo nix-env -iA "${deps_to_install[*]}") || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo nix-channel --update && (IFS=' nixos.'; sudo nix-env -iA "${deps_to_install[*]}") || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo nix-env -u && (IFS=' nixos.'; sudo nix-env -iA "${deps_to_install[*]}") || exit $?
                    else
                        (IFS=' nixos.'; sudo nix-env -iA "${deps_to_install[*]}") || exit $?
                    fi
                    ;;

                *guix*) # --- Guix ---
                    if [ $FETCH -eq 1 ] && [ $UPGRADE -eq 1 ]; then
                        sudo guix pull && sudo guix package -u && sudo package -i ${deps_to_install[@]} || exit $?
                    elif [ $FETCH -eq 1 ]; then
                        sudo guix pull && sudo package -i ${deps_to_install[@]} || exit $?
                    elif [ $UPGRADE -eq 1 ]; then
                        sudo guix package -u && sudo package -i ${deps_to_install[@]} || exit $?
                    else
                        sudo package -i ${deps_to_install[@]} || exit $?
                    fi
                    ;;

                *) echo "Unknown how to install dependencies for this linux"; exit 1;;
            esac
            ;;

        macos) # --- MacOS ---
            if ! command -v brew >/dev/null 2>&1; then
                echo     "\033[92mHomebrew\033[0m is not installed"
                while true; do
                    echo -en "Install \033[92mhomebrew\033[0m and \033[92mdependencies\033[0m? [Y/n] "
                    read responce
                    case "$responce" in
                        [Yy]|'') /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit $?; break;;
                        [Nn]) exit 1;;
                    esac
                done
            fi
            brew update && brew install ${DEPS[@]} || exit $?
            ;;

        # --- Android (Termux) ---
        android-termux) pkg install ${DEPS[@]} || exit $?;;

        # --- Windows ---
        windows-msys2) pacman -S --needed ${DEPS[@]} || exit $?;;
        windows-cygwin)
            # Checking for apt-cyg
            if command -v apt-cyg >/dev/null 2>&1; then
                # --- Installing via apt-cyg ---
                apt-cyg update && apt-cyg install ${DEPS[@]} || exit $?
            else
                # --- Installing via official setup-x86_64.exe ---
                if [ -n "$XDG_CACHE_HOME" ]; then
                    CACHE="$XDG_CACHE_HOME/dotfiles"
                else
                    CACHE="$HOME/.cache/dotfiles"
                fi

                curl -o "$CACHE/setup-x86_64.exe" 'https://www.cygwin.com/setup-x86_64.exe' || exit $?
                (IFS=','; "$CACHE/setup-x86_64.exe" -q -P "${DEPS[*]}" -g || exit $?)

                rm -f "$CACHE/setup-x86_64.exe" && rm -df "$CACHE"
            fi
            ;;

        *) echo "Unknown how to install dependencies for this system"; exit 1;;
    esac
else
    echo "There is nothing to do"
fi

exit 0
