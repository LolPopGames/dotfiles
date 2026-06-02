#!/usr/bin/env sh

# Showing help if --help was entered
if [ "$1" = "--help" ]; then
    printf "Sets up configuration file for LolPopGames' dotfiles\n"
    exit 0
fi

# Configuration file
CONFIG="config.sh"
printf '' > "$CONFIG"
printf '%s\n' "#!/usr/bin/env sh
# Configuration file for LolPopGames' dotfiles" >> "$CONFIG"

# --- Enabling capability mode for Zsh ---
if [ -n "$ZSH_VERSION" ]; then
    setopt SH_WORD_SPLIT
fi
printf '%s\n' "
# Enabling capability mode for Zsh
if [ -n \"\$ZSH_VERSION\" ]; then
    setopt SH_WORD_SPLIT
fi" >> "$CONFIG"

# --- Finding repository dir ---
REPO="$(dirname $(readlink -f "$0"))"
MODULES="$REPO/modules"

. "$MODULES/escaping.sh"
printf '%s\n' "
# Repository dir
REPO=\"$(shell_escape_quote "$REPO")\"
MODULES=\"$(shell_escape_quote "$MODULES")\"" >> "$CONFIG"

# --- Enabling Colors ---
. "$MODULES/colors.sh"

# --- Determining OS ---
os_name_=$(uname -s)

case "$os_name_" in
    # --- Linux ---
    Linux*)
        case "$(uname -o)" in
            Android*) # --- Android ---
                if [ -n "$TERMUX_VERSION" ]; then
                    OS_NAME=android-termux
                elif [ -n "$ANDROID_PROPERTY_WORKSPACE" ]; then
                    OS_NAME=android-adb
                else
                    OS_NAME=android
                fi
                OS_COLOR='#85c446' OS_COLOR_XTERM=113 OS_COLOR_BASE16='green' OS_ICON='󰀲';;

            *) # --- Linux ---
                if [ -f /etc/os-release ]; then
                    . /etc/os-release
                    OS_NAME="linux-$ID"
                    case "$ID" in
                        debian|peppermint|neptune|bunsenlabs|antix|crunchbangplusplus|sparky|whonix|pureos|q4os|endless) OS_COLOR_RGB='#a7002e' OS_COLOR_XTERM=124 OS_COLOR_BASE16='red' OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        ubuntu|ubuntu-mate|ubuntu-budgie|xubuntu|lubuntu|ubuntu-studio|feren|voyager|ubuntu-kylin|tuxedo|caine|backbox) OS_COLOR_RGB='#ea5516' OS_COLOR_XTERM=166 OS_COLOR_BASE16=9 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        linuxmint|ldme) OS_COLOR_RGB='#6eb745' OS_COLOR_XTERM=71 OS_COLOR_BASE16=10 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        elementary) OS_COLOR_RGB='#4aa5e9' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        pop) OS_COLOR_RGB='#48b9c7' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        kali) OS_COLOR_RGB='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        parrot) OS_COLOR_RGB='#16e6f2' OS_COLOR_XTERM=45 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        zorin) OS_COLOR_RGB='#15a6f0' OS_COLOR_XTERM=39 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        deepin) OS_COLOR_RGB='#33c5ff' OS_COLOR_XTERM=81 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        mx|avlinux) OS_COLOR_RGB='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        kubuntu) OS_COLOR_RGB='#087dc3' OS_COLOR_XTERM=31 OS_COLOR_BASE16='blue' OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        devuan) OS_COLOR_RGB='#494857' OS_COLOR_XTERM=239 OS_COLOR_BASE16=8 OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        tails) OS_COLOR_RGB='#5b3a80' OS_COLOR_XTERM=60 OS_COLOR_BASE16='magenta' OS_ICON='' LINUX_FAMILY_BRANCH='debian';;
                        fedora|amzn|nst|fedora-coreos) OS_COLOR_RGB='#56a5db' OS_COLOR_XTERM=74 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='fedora';;
                        rhel|ol|scientific|eurolinux|miraclelinux|navylinux|virtuozzo) OS_COLOR_RGB='#cf0808' OS_COLOR_XTERM=160 OS_COLOR_BASE16='red' OS_ICON='' LINUX_FAMILY_BRANCH='rhel';;
                        centos|clearos) OS_COLOR_RGB='#f0aa2b' OS_COLOR_XTERM=214 OS_COLOR_BASE16='yellow' OS_ICON='' LINUX_FAMILY_BRANCH='rhel';;
                        rocky) OS_COLOR_RGB='#17bb85' OS_COLOR_XTERM=36 OS_COLOR_BASE16=10 OS_ICON='' LINUX_FAMILY_BRANCH='rhel';;
                        almalinux) OS_COLOR_RGB='#ff4c4f' OS_COLOR_XTERM=203 OS_COLOR_BASE16=9 OS_ICON='' LINUX_FAMILY_BRANCH='rhel';;
                        arch|blackarch|archbang|rebornos|archman|chimera|cachy) OS_COLOR_RGB='#1793d1' OS_COLOR_XTERM=32 OS_COLOR_BASE16='cyan' OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        manjaro) OS_COLOR_RGB='#3bc161' OS_COLOR_XTERM=71 OS_COLOR_BASE16=10 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        endeavouros) OS_COLOR_RGB='#8345c1' OS_COLOR_XTERM=97 OS_COLOR_BASE16=13 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        garuda) OS_COLOR_RGB='#2fa7f2' OS_COLOR_XTERM=39 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        artix) OS_COLOR_RGB='#64bed9' OOS_COLOR_XTERM=74 OS_COLOR_BASE16=14 S_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        arcolinux) OS_COLOR_RGB='#6c93ec' OS_COLOR_XTERM=69 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        archcraft) OS_COLOR_RGB='#86bba6' OS_COLOR_XTERM=109 OS_COLOR_BASE16=10 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        archlabs) OS_COLOR_RGB='#363637' OS_COLOR_XTERM=237 OS_COLOR_BASE16=0 OS_ICON='' LINUX_FAMILY_BRANCH='arch';;
                        steamos) OS_COLOR_RGB='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON=''  LINUX_FAMILTY_BRANCH='arch';;
                        opensuse-tumbleweed|geckolinux|opensuse-microos) OS_COLOR_RGB='#77bc2c' OS_COLOR_XTERM=106 OS_COLOR_BASE16='green' OS_ICON='' LINUX_FAMILY_BRANCH='opensuse';;
                        opensuse-leap|sles) OS_COLOR_RGB='#69b54b' OS_COLOR_XTERM=71 OS_COLOR_BASE16='green' OS_ICON='' LINUX_FAMILY_BRANCH='opensuse';;
                        gentoo|calculate|redcore) OS_COLOR_RGB='#9c94da' OS_COLOR_XTERM=140 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='gentoo';;
                        sabayon) OS_COLOR_RGB='#3c464b' OS_COLOR_XTERM=238 OS_COLOR_BASE16=8 OS_ICON='' LINUX_FAMILY_BRANCH='gentoo';;
                        alpine) OS_COLOR_RGB='#155e83' OS_COLOR_XTERM=24 OS_COLOR_BASE16='blue' OS_ICON='' LINUX_FAMILY_BRANCH='alpine';;
                        void) OS_COLOR_RGB='#4d8466' OS_COLOR_XTERM=65 OS_COLOR_BASE16='green' OS_ICON='' LINUX_FAMILY_BRANCH='void';;
                        nixos) OS_COLOR_RGB='#577cc5' OS_COLOR_XTERM=68 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='nixos';;
                        slakeware) OS_COLOR_RGB='#4f67b1' OS_COLOR_XTERM=61 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='slakeware';;
                        solus) OS_COLOR_RGB='#525768' OS_COLOR_XTERM=240 OS_COLOR_BASE16=8 OS_ICON='' LINUX_FAMILY_BRANCH='solus';;
                        mageia) OS_COLOR_RGB='#2d364b' OS_COLOR_XTERM=237 OS_COLOR_BASE16='black' OS_ICON='' LINUX_FAMILY_BRANCH='openmadriva';;
                        openmandriva|rosa) OS_COLOR_RGB='#42a4d8' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='' LINUX_FAMILY_BRANCH='openmadriva';;
                        obsd) OS_COLOR_RGB='#f2dc77' OS_COLOR_XTERM=222 OS_COLOR_BASE16=11 OS_ICON='' LINUX_FAMILY_BRANCH='openmadriva';;
                        qubes) OS_COLOR_RGB='#68a3ff' OS_COLOR_XTERM=75 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='qubes';;
                        coreos|flatcar) OS_COLOR_RGB='#58a6db' OS_COLOR_XTERM=74 OS_COLOR_BASE16=12 OS_ICON='' LINUX_FAMILY_BRANCH='coreos';;
                        *) OS_COLOR_RGB='#f7c017' OS_COLOR_XTERM=214 OS_COLOR_BASE16='yellow' OS_ICON='' LINUX_FAMILY_BRANCH='unknown';;
                    esac

                    # If /etc/os-release declared color
                    if [ -n "$ANSI_COLOR" ]; then
                        case "$ANSI_COLOR" in
                            38\;2\;*) # rgb
                                ANSI_COLOR="${ANSI_COLOR#38;2;}"
                                RED_COLOR="${ANSI_COLOR%%;*}"
                                ANSI_COLOR="${ANSI_COLOR#*;}"
                                GREEN_COLOR="${ANSI_COLOR%;*}"
                                BLUE_COLOR="${ANSI_COLOR#*;}"

                                OS_COLOR_RGB="$(printf '#%02x%02x%02x' "$RED_COLOR" "$GREEN_COLOR" "$BLUE_COLOR")"
                                OS_COLOR_XTERM="$(rgb_to_xterm256 "$RED_COLOR" "$GREEN_COLOR" "$BLUE_COLOR")"
                                OS_COLOR_BASE16="$(rgb_to_base16 "$RED_COLOR" "$GREEN_COLOR" "$BLUE_COLOR")";;

                            38\;5\;*) # xterm256
                                OS_COLOR_XTERM="${ANSI_COLOR#38;5;}"
                                OS_COLOR_RGB="$OS_COLOR_RGB"
                                OS_COLOR_BASE16="$(xterm_to_base16 "$OS_COLOR_XTERM")";;

                            3?|9?) # base16
                                case "$ANSI_COLOR" in
                                    3?) OS_COLOR_BASE16="$((ANSI_COLOR - 30))";; # 30-37 = 0-7
                                    9?) OS_COLOR_BASE16="$((ANSI_COLOR - 82))";; # 90-97 = 8-15
                                esac
                                OS_COLOR_XTERM="$OS_COLOR_BASE16" OS_COLOR_RGB="$OS_COLOR_BASE16";;
                        esac

                        case "$OS_COLOR_RGB" in
                            0) OS_COLOR_RGB='black';;
                            1) OS_COLOR_RGB='red';;
                            2) OS_COLOR_RGB='green';;
                            3) OS_COLOR_RGB='yellow';;
                            4) OS_COLOR_RGB='blue';;
                            5) OS_COLOR_RGB='magenta';;
                            6) OS_COLOR_RGB='cyan';;
                            7) OS_COLOR_RGB='white';;
                        esac
                        case "$OS_COLOR_XTERM" in
                            0) OS_COLOR_XTERM='black';;
                            1) OS_COLOR_XTERM='red';;
                            2) OS_COLOR_XTERM='green';;
                            3) OS_COLOR_XTERM='yellow';;
                            4) OS_COLOR_XTERM='blue';;
                            5) OS_COLOR_XTERM='magenta';;
                            6) OS_COLOR_XTERM='cyan';;
                            7) OS_COLOR_XTERM='white';;
                        esac
                        case "$OS_COLOR_BASE16" in
                            0) OS_COLOR_BASE16='black';;
                            1) OS_COLOR_BASE16='red';;
                            2) OS_COLOR_BASE16='green';;
                            3) OS_COLOR_BASE16='yellow';;
                            4) OS_COLOR_BASE16='blue';;
                            5) OS_COLOR_BASE16='magenta';;
                            6) OS_COLOR_BASE16='cyan';;
                            7) OS_COLOR_BASE16='white';;
                        esac
                    fi
                else
                    OS_NAME=linux-unknown
                fi
        esac;;

    # --- MacOS ---
    Darwin*) OS_NAME=macos OS_COLOR_RGB='#080808' OS_COLOR_XTERM='black' OS_COLOR_BASE16='black' OS_ICON='';;

    # --- Windows (Msys2/Git Bash) ---
    CYGWIN*)      OS_NAME=windows-cygwin    OS_COLOR_RGB='#08b0f1' OS_COLOR_XTERM=39 OS_COLOR_BASE16=14 OS_ICON='';;
    MSYSTEM*)     OS_NAME=windows-msys2     OS_COLOR_RGB='#08b0f1' OS_COLOR_XTERM=39 OS_COLOR_BASE16=14 OS_ICON='';;
    MSYS*|MINGW*) OS_NAME=windows-gitbash   OS_COLOR_RGB='#08b0f1' OS_COLOR_XTERM=39 OS_COLOR_BASE16=14 OS_ICON='';;

    # --- Other ---
    *) OS_NAME=unknown;;
esac

printf "
# System Stats
OS_NAME='%s'\n" "$OS_NAME" >> "$CONFIG"

if [ -n "$LINUX_FAMILY_BRANCH" ]; then
    printf '%s\n' "LINUX_FAMILY_BRANCH='$LINUX_FAMILY_BRANCH'" >> "$CONFIG"
fi

printf '%s\n' "OS_ICON='$OS_ICON'" >> "$CONFIG"

case "$OS_COLOR_RGB" in
    ''|[!0123456789]*) printf "OS_COLOR_RGB='%s'\n" "$OS_COLOR_RGB" >> "$CONFIG";;
    *)                 printf "OS_COLOR_RGB=%s\n"   "$OS_COLOR_RGB" >> "$CONFIG";;
esac
case "$OS_COLOR_XTERM" in
    ''|[!0123456789]*) printf "OS_COLOR_XTERM='%s'\n" "$OS_COLOR_XTERM" >> "$CONFIG";;
    *)                 printf "OS_COLOR_XTERM=%s\n"   "$OS_COLOR_XTERM" >> "$CONFIG";;
esac
case "$OS_COLOR_BASE16" in
    ''|[!0123456789]*) printf "OS_COLOR_BASE16='%s'\n" "$OS_COLOR_BASE16" >> "$CONFIG";;
    *)                 printf "OS_COLOR_BASE16=%s\n"   "$OS_COLOR_BASE16" >> "$CONFIG";;
esac

# --- Choosing What To Install ---
confs=""
deps=""
optdeps=""
dep_output=""

. "$MODULES/deps.sh"

# Usage:
#   add_dep DEP...
# Description
#   Adds required dependencies
add_dep() {
    for arg in "$@"; do
        # Exiting if already exists in $deps
        continue_next=0
        for dep in $deps; do
            [ "$arg" = "$dep" ] && continue_next=1 && break
        done
        [ $continue_next -eq 1 ] && continue

        # Revoming from $optdeps and adding to $deps, if found
        for dep in $optdeps; do
            if [ "$arg" = "$dep" ]; then
                # Adding to $deps
                deps="$deps $arg"

                # Removing from optional dependencies
                optdeps_prefix="${optdeps%%"$arg"*}"
                optdeps_suffix="${optdeps#*"$arg "}"
                optdeps="${optdeps_prefix}${optdeps_suffix}"

                # Changing color in $dep_output
                if [ -n "${YELLOW}" ]; then case "$dep_output" in
                    *"${YELLOW}$arg${RESET}"*)
                        dep_output_prefix="${dep_output%%"${YELLOW}$arg${RESET}"*}"
                        dep_output_suffix="${dep_output#*"${YELLOW}$arg${RESET}"}"
                        dep_output="${dep_output_prefix}${RED}$arg${RESET}${dep_output_suffix}"
                        ;;
                esac; fi

                continue_next=1
                break
            fi
        done
        [ $continue_next -eq 1 ] && continue

        # If non of above, adding to $deps
        if dep_present "$arg"; then
            dep_output="$dep_output ${GREEN}$arg${RESET}"
        deps="$deps $arg"
        else
            dep_output="$dep_output ${RED}$arg${RESET}"
        fi
    done
}

# Usage:
#   add_opt_dep DEP...
# Description:
#   Adds optional dependencies
add_opt_dep() {
    for arg in "$@"; do
        # Exiting if already exists in $deps
        continue_next=0
        for dep in $deps; do
            [ "$arg" = "$dep" ] && continue_next=1 && break
        done
        [ $continue_next -eq 1 ] && continue

        # Exiting if already exists in $optdeps
        for dep in $optdeps; do
            [ "$arg" = "$dep" ] && continue_next=1 && break
        done
        [ $continue_next -eq 1 ] && continue

        # If non of above, adding to $optdeps
        optdeps="$optdeps $arg"
        if dep_present "$arg"; then
            dep_output="$dep_output ${GREEN}$arg${RESET}"
        else
            dep_output="$dep_output ${YELLOW}$arg${RESET}"
        fi
    done
}

# Usage:
#   check_for_config [-n] CONFIG
# Description:
#   Checks to install a config
# Options:
#   -n  Do not add dep to $deps
check_for_config() {
    add_as_dep=1
    if [ "$1" = '-n' ]; then
        add_as_dep=0
        shift
    fi

    present=0
    if dep_present "$1"; then
        present=1
    fi
    case " $deps $optdeps " in
        *" $1 "*) present=1;;
    esac

    if [ $present -eq 1 ]; then
        while true; do
            printf "Install config for ${LIGHT_GREEN}%s${RESET}? [${BOLD}Y${RESET}/n] " "$1"
            read responce
            case "$responce" in
                [Yy]|'')
                    confs="$confs $1"

                    [ "$add_as_dep" -eq 1 ] && add_dep "$1"
                    return 0;;
                [Nn]) return 1;;
            esac
        done
    else
        while true; do
            printf "Install config for ${LIGHT_RED}%s${RESET}? [y/${BOLD}N${RESET}] " "$1"
            read responce
            case "$responce" in
                [Nn]|'') return 1;;
                [Yy])
                    confs="$confs $1"

                    [ "$add_as_dep" -eq 1 ] && add_dep "$1"
                    return 0;;
            esac
        done
    fi
}

check_for_config hyprland && add_opt_dep uwsm kitty thunar nwg-drawer firefox mako vim gnome-calculator flameshot waybar wl-clipboard hyprpicker swaybg
check_for_config zsh && add_opt_dep jq
check_for_config waybar
check_for_config mako
check_for_config kitty
check_for_config -n vim && add_dep gvim
check_for_config cava
check_for_config mintty
check_for_config gdb
check_for_config rofi

# Removing trailing spaces
confs="${confs#?}"
deps="${deps#?}"
optdeps="${optdeps#?}"
dep_output="${dep_output#?}"

printf "
# Configuration
CONFS='%s'
DEPS='%s'
OPTDEPS='%s'\n" "$confs" "$deps" "$optdeps" >> "$CONFIG"

# --- Printing dependencies ---
printf 'Dependencies: %b\n\n' "$dep_output"

# --- Checking to install repository ---
printf "
# This is would we install repository to ${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles
INSTALL_REPO=" >> "$CONFIG"

while true; do
    printf "Install repository to ${LIGHT_GREEN}${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles${RESET} to receive updates? [Y/n] " "$1"
    read responce
    case "$responce" in
        [Yy]|'') printf "1\n" >> "$CONFIG"; break;;
        [Nn])    printf "0\n" >> "$CONFIG"; break;;
    esac
done
