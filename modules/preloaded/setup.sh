#!/usr/bin/env sh
# Preloaded for Setup Module
if [ -z "$_setup_preloaded_sh__included" ]; then
_setup_preloaded_sh__included=1

# --- Parsing Arguments ---
display_help() {
cat << EOF
Usage: $0 [OPTION]...
Make configuration file for ${LIGHT_CYAN}LolPopGames'${RESET} ${CONFIG_TYPE}dotfiles

  ${BOLD}-i, --indent${RESET}
         make '=>' identation for every dialogue

  ${BOLD}-h, --help${RESET}
         display this help and exit

  ${BOLD}-v, --version${RESET}
         output version information and exit

The script will make a ${LIGHT_GREEN}config.sh${RESET} file

Report bugs to: <https://github.com/LolPopGames/dotfiles/issues/>
LolPopGames' dotfiles repository: <https://github.com/LolPopGames/dotfiles/>
EOF

    exit
}

# Empty mean 0, 1 mean 1
INDENT=
find_long_option() case "$1" in
    --h|--he|--hel|--help) display_help;;
    --v|--ve|--ver|--vers|--versi|--versio|--version) display_version;;
    --i|--in|--ind|--inde|--inden|--indent) INDENT=1;;
    --*) return 1;;
esac


find_option() case "$str" in
    h*) display_help;;
    v*) display_version;;
    i*) INDENT=1;;
    *) return 1;;
esac

parse_args "$@"

# --- Adding Prologue ---
cat > "$CONFIG" << EOF
#!/bin/sh
# Configuration file for LolPopGames' ${CONFIG_NAME}dotfiles

EOF

# --- Adding Deps Functions ---
# Usage:
#   add_dep DEP...
# Description
#   Add required dependencies to $deps
add_dep() {
    _add_dep__start=1
    while [ $# -gt 0 ]; do
        [ $_add_dep__start -eq 0 ] && shift || _add_dep__start=0

        # Exiting if already exists in $deps
        case " $deps " in (*" $1 "*) continue;; esac

        # Revoming from $optdeps and adding to $deps, if found
        case " $optdeps " in (*" $1 "*)
            # Adding to $deps
            deps="$deps $1"

            # Removing from optional dependencies
            optdeps=" $optdeps "
            _add_dep__prefix="${optdeps%%" $1 "*}"
            _add_dep__suffix="${optdeps#*" $1 "}"
            _add_dep__prefix="${_add_dep__prefix# }" _add_dep__suffix="${_add_dep__suffix% }"
            optdeps="${_add_dep__prefix:+"$_add_dep__prefix "}${_add_dep__suffix}"

            # Changing color in $dep_output
            case "$dep_output" in (*"${YELLOW}$1${RESET}"*) # Skipping if dep is already green
                _add_dep__prefix="${dep_output%%"${YELLOW}$1${RESET}"*}"
                _add_dep__suffix="${dep_output#*"${YELLOW}$1${RESET}"}"
                dep_output="${_add_dep__prefix}${RED}$1${RESET}${_add_dep__suffix}";;
            esac

            continue;;
        esac


        # If non of above, just adding to $deps
        deps="$deps $1"
        if dep_present "$1"; then
            dep_output="$dep_output ${GREEN}$1${RESET}"
        else
            dep_output="$dep_output ${RED}$1${RESET}"
        fi
    done
}

# Usage:
#   add_optdep DEP...
# Description:
#   Add optional dependencies to $optdeps
add_optdep() {
    _add_dep__start=1
    while [ $# -gt 0 ]; do
        [ $_add_dep__start -eq 0 ] && shift || _add_dep__start=0

        # Exiting if already exists in $deps or $optdeps
        case " $deps $optdeps " in (*" $1 "*) continue;; esac

        # Adding to $optdeps
        optdeps="$optdeps $1"
        if dep_present "$1"; then
            dep_output="$dep_output ${GREEN}$1${RESET}"
        else
            dep_output="$dep_output ${YELLOW}$1${RESET}"
        fi
    done
}

# --- Ask Functions ---
# Usage:
#   ask_yesno "question" ([Yy]/[Nn])
# Description:
#   Ask something with default answer Yes or No
ask_yesno() {
    case "$2" in
        [Yy])
            while true; do
                printf "${INDENT:+"${LIGHT_GREEN}=>${RESET} "}%b? [${BOLD}Y${RESET}/n] " "$1" >&2
                read _ask_yesno__responce
                case "$_ask_yesno__responce" in
                    [Yy]|'') return;;
                    [Nn]) return 1;;
                esac
            done;;
        [Nn])
            while true; do
                printf "${INDENT:+"${LIGHT_RED}=>${RESET} "}%b? [y/${BOLD}N${RESET}] " "$1" >&2
                read _ask_yesno__responce
                case "$_ask_yesno__responce" in
                    [Yy]) return;;
                    [Nn]|'') return 1;;
                esac
            done;;
    esac
}

# Usage:
#   ask_choice "question" CHOICE...
# Description:
#   Ask something with several choices.
#   The first choice is the default choice.
ask_choice() (
    _ask_choice__question="$1"
    _ask_choice__first="$2"
    shift 2
    IFS='/'

    while true; do
        printf "${INDENT:+"${LIGHT_GREEN}=>${RESET} "}%b? (${BOLD}%b${RESET}/%b) " "$_ask_choice__question" "$_ask_choice__first" "$*" >&2
        read _ask_choice__responce
        _ask_choice__responce="$(
            printf '%s' "$_ask_choice__responce" |
            sed 's/^[[:space:]]*//g' |
            sed 's/[[:space:]]*$//g' |
            sed 's/[[:space:]]/-/g'
        )"
        case "$_ask_choice__responce" in (''|*" $_ask_choice__first $* "*) printf '%s' "${_ask_choice__responce:-"$_ask_choice__first"}"; return;; esac
    done
)

# Usage:
#   ask_for_config CONFIG
# Description:
#   Ask to install a config
ask_for_config() {
    _ask_for_config__continue=
    while [ $# -gt 0 ]; do
        if [ -n "$_ask_for_config__continue" ]; then
            shift
            _ask_for_config__continue=
        fi
        [ $# -eq 0 ] && break
        case "$1" in (*" $confs "*) continue;; esac
        
        if dep_present "$1"; then
            if ! ask_yesno "Install config for ${LIGHT_GREEN}$1${RESET}" y; then
                _ask_for_config__continue=1
                continue
            fi
        else
            if ! ask_yesno "Install config for ${LIGHT_RED}$1${RESET}" n; then
                _ask_for_config__continue=1
                continue
            fi
        fi

        confs="$confs $1"
        "$DIR/configs/$1/setup.sh" -i
        {
            read -r _ask_for_config__deps
            add_dep $_ask_for_config__deps
            read -r _ask_for_config__optdeps
            add_optdep $_ask_for_config__optdeps
        } << EOF
$("$DIR/configs/$1/install-deps.sh" -p)


EOF
        shift
    done
}

# --- Auto Install Function ---
# Usage:
#   auto_install
# Description:
#   Run install-deps.sh and install.sh
auto_install() {
    printf '\n'
    if ask_yesno "${LIGHT_GREEN}Install${RESET} ${CONFIG_NAME}dependencies and configurations right now" y; then
        printf '==> Installing dependencies...\n'
        "$DIR/install-deps.sh"
        printf '==> Installing configurations...\n'
        "$DIR/install.sh"
    fi
}

# --- Output Deps Function ---
# Usage:
#   output_deps
# Description:
#   Output $confs, $deps and $optdeps to $CONFIG
output_deps() {
    # Removing trailing whitespace
    confs="${confs# }"
    deps="${deps# }"
    optdeps="${optdeps# }"
    dep_output="${dep_output# }"

cat >> "$CONFIG" << EOF
# ${confs:+"Configs & "}Dependencies${confs:+"
CONFS='$confs'"}
DEPS='$deps'
OPTDEPS='$optdeps'
EOF

    # Printing dependencies
    if [ -z "$INDENT" ]; then
        printf 'Dependencies: %s\n' "$dep_output" 
        auto_install
    fi
}

fi
