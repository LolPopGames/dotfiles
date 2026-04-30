#!/usr/bin/env sh

# --- Opening Config ---
case "$1" in
    -h|--help)
        echo -e "Usage: \033[92m$0\033[0m \033[94m[-c CONFIG]\033[0m"
        echo -e "Install dependencies for \033[96mLolPopGames'\033[0m dotfiles"
        echo
        echo    "Options:"
        echo -e "    \033[94m-c CONFIG\033[0m  install deps with custom config filename instead of \033[92mconfig.sh\033[0m"

        exit 0
        ;;
    -c)
        if [ "$(expr "$2" : '\(.\)')" = '/' ]; then
            CONFIG="$2"
        else
            CONFIG="./$2"
        fi
        ;;
    *)  CONFIG="./config.sh";;
esac

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    SETUP="$(dirname "$0" | tr -d $'\n')/setup.sh"
    echo     "$CONFIG: File not found" >&2
    echo -en "Generate \033[92m$CONFIG\033[0m with \033[92m$SETUP"
    if [ "$CONFIG" != 'config.sh' ]; then
        echo -e " -o $CONFIG\033[0m"
    else
        echo -e "\033[0m"
    fi
fi

case "$OS_NAME" in
    linux-*)
        case "$OS_NAME $LINUX_ID_LIKE" in
            *arch*) sudo pacman -Syu --color=auto --needed ${DEPS[@]} || exit $?;;
            *debian*|*ubuntu*|*pclinuxos*) sudo apt update && sudo apt install ${DEPS[@]} || exit $?;;
            *rhel*|*fedora*) sudo dnf install ${DEPS[@]} || exit $?;;
            *opensuse*|*sles*) sudo zypper refresh && sudo zypper install ${DEPS[@]} || exit $?;;
            *gentoo*) sudo emerge --sync && sudo emerge -a ${DEPS[@]} || exit $?;;
            *alpine*) sudo apk update && sudo apk add ${DEPS[@]} || exit $?;;
            *clear-linux-os*) sudo swupd bundle-add ${DEPS[@]} || exit $?;;
            *solus*) sudo eopkg update-repo && sudo eopkg install ${DEPS[@]} || exit $?;;
            *void*) sudo xbps-install ${DEPS[@]} || exit $?;;
            *nixos*) sudo nix-channel --update && (IFS=' nixos.'; sudo nix-env -iA "${DEPS[*]}") || exit $?;;
            *guix*) sudo guix pull && sudo guix package -i ${DEPS[@]} || exit $?;;
            *) echo "Unknown how to install dependencies for this linux"; exit 1;;
        esac
        ;;

    macos)
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

    android-termux) pkg install ${DEPS[@]} || exit $?;;

    windows-msys2) pacman -S --needed ${DEPS[@]} || exit $?;;
    windows-cygwin)
        if command -v apt-cyg >/dev/null 2>&1; then
            apt-cyg update && apt-cyg install ${DEPS[@]} || exit $?
        fi

        if [ -n "$XDG_CACHE_HOME" ]; then
            CACHE="$XDG_CACHE_HOME/dotfiles"
        else
            CACHE="$HOME/.cache/dotfiles"
        fi

        curl -o "$CACHE/setup-x86_64.exe" 'https://www.cygwin.com/setup-x86_64.exe' || exit $?
        (IFS=','; "$CACHE/setup-x86_64.exe" -q -P "${DEPS[*]}" -g || exit $?)

        rm -f "$CACHE/setup-x86_64.exe" && rm -df "$CACHE"
        ;;

    *) echo "Unknown how to install dependencies for this system"; exit 1;;
esac

exit 0
