#!/usr/bin/env sh

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

# --- Config and Modules ---
DIR="$(dirname "$(readlink -m "$0")")"
CONFIG="$DIR/config.sh"
MODULES="$DIR/../../modules"
SRC="$DIR/src"

# --- Getting Infomation
. "$MODULES/colors.sh"
while true; do
    printf "Where will be ${LIGHT_GREEN}output dir${RESET}? (${BOLD}inconfig${RESET}/home) "
    read responce
    case "$responce" in
        ''|inconfig) OUTPUT_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh";;
        home)        OUTPUT_DIR="$HOME";;
        *) continue;;
    esac
    break
done

while true; do
    printf "Add sudo shortcut for ${LIGHT_GREEN}ctrl+enter${RESET} (preconfigured kitty is needed)? (Y/n) "
    read responce
    case "$responce" in
        ''|[Yy]) ADD_SUDO_SHORTCUT=1;;
        [Nn])    ADD_SUDO_SHORTCUT=0;;
        *) continue;;
    esac
    break
done

while true; do
    printf "Which ${LIGHT_GREEN}theme${RESET} to use? (${BOLD}colorful${RESET}/bash/minimal) "
    read responce
    case "$responce" in
        ''|colorful) PROMPT_STYLE='colorful';;
        bash)        PROMPT_STYLE='bash';;
        minimal)     PROMPT_STYLE='minimal';;
        *) continue;;
    esac
    break
done

if [ "$PROMPT_STYLE" != 'bash' ]; then
    PROMPT_SIGN='bash'
else
    while true; do
        printf "Which type of ${LIGHT_GREEN}prompt sign${RESET} ($/#) to use? (${BOLD}bash${RESET}/zsh) "
        read responce
        case "$responce" in
            ''|bash) PROMPT_SIGN='bash';;
            zsh)     PROMPT_SIGN='zsh';;
            *) continue;;
        esac
        break
    done
fi

if [ "$PROMPT_STYLE" != 'colorful' ]; then
    CHAR_SET='nerdfonts'
    COLOR_SET='truecolor'
    case "$OS_NAME" in
        android-*) SHOW_BATTERY_LEVEL=1;;
        *)         SHOW_BATTERY_LEVEL=0;;
    esac
    BATTERY_GREEN_LEVEL=60
    BATTERY_YELLOW_LEVEL=20
    MAKE_NEWLINE_IF_NEEDED=1
    MANAGE_DIR_ICON=1
    ENABLE_GIT=1
    SHOW_EXEC_TIME=1
else
    while true; do
        printf "Which ${LIGHT_GREEN}char set${RESET} to use? (${BOLD}nerdfonts${RESET}/utf-8/ascii) "
        read responce
        case "$responce" in
            ''|nerdfonts) CHAR_SET='nerdfonts';;
            utf-8)        CHAR_SET='utf-8';;
            ascii)        CHAR_SET='ascii';;
            *) continue;;
        esac
        break
    done

    while true; do
        printf "Which ${LIGHT_GREEN}color set${RESET} to use? (${BOLD}truecolor${RESET}/xterm256/base16) "
        read responce
        case "$responce" in
            ''|truecolor) COLOR_SET='truecolor';;
            xterm256)     COLOR_SET='xterm256';;
            base16)       COLOR_SET='base16';;
            *) continue;;
        esac
        break
    done

    case "$OS_NAME" in
        android-*)
            while true; do
                printf "Show Android's ${LIGHT_GREEN}battery level${RESET}? (Y/n) "
                read responce
                case "$responce" in
                    ''|[Yy]) SHOW_BATTERY_LEVEL=1;;
                    [Nn])    SHOW_BATTERY_LEVEL=0;;
                    *) continue;;
                esac
                break
            done;;
        *)
            while true; do
                printf "Show Android's ${LIGHT_RED}battery level${RESET}? (y/N) "
                read responce
                case "$responce" in
                    [Yy])    SHOW_BATTERY_LEVEL=1;;
                    ''|[Nn]) SHOW_BATTERY_LEVEL=0;;
                    *) continue;;
                esac
                break
            done;;
    esac

    if [ "$SHOW_BATTERY_LEVEL" -eq 1 ]; then
        while true; do
            printf "What will be minimal ${LIGHT_GREEN}green${RESET} battery level (from X up to 100%%)? (${BOLD}60%%${RESET}) "
            read responce
            case "$responce" in
                '')                      BATTERY_GREEN_LEVEL=60;;
                [1-9]%|[1-9][0-9]%|100%) BATTERY_GREEN_LEVEL="${responce%'%'}";;
                *) continue;;
            esac
            break
        done

        maximum="$((BATTERY_GREEN_LEVEL-1))"
        if [ "$BATTERY_GREEN_LEVEL" -gt 20 ]; then
            recommended=20
        else
            recommended="$maximum"
        fi
        while true; do
            printf "What will be minimal ${LIGHT_YELLOW}yellow${RESET} battery level (from X up to $maxiumum%%)? (${BOLD}$recommended%%${RESET}) "
            read responce
            case "$responce" in
                '') BATTERY_YELLOW_LEVEL="$recommended"; break;;
                *%) responce="${responce%'%'}";;
                *) continue;;
            esac

            case "$responce" in
                ''|*[!0-9]*) continue;;
                [0-9]*) case "$responce" in (0*) continue;; esac;;
            esac

            if [ "$responce" -ge 1 ] && [ "$responce" -le "$maximum" ]; then
                BATTERY_YELLOW_LEVEL="$responce"
                break
            fi
        done
    else
        BATTERY_LEVEL_GREEN=60
        BATTERY_LEVEL_YELLOW=20
    fi

    while true; do
        printf "Make ${LIGHT_GREEN}newline${RESET} if needed? (Y/n) "
        read responce
        case "$responce" in
            ''|[Yy]) MAKE_NEWLINE_IF_NEEDED=1;;
            [Nn])    MAKE_NEWLINE_IF_NEEDED=0;;
            *) continue;;
        esac
        break
    done

    while true; do
        printf "Manage ${LIGHT_GREEN}dir icon${RESET}? (Y/n) "
        read responce
        case "$responce" in
            ''|[Yy]) MANAGE_DIR_ICON=1;;
            [Nn])    MANAGE_DIR_ICON=0;;
            *) continue;;
        esac
        break
    done

    while true; do
        printf "Enable ${LIGHT_GREEN}git${RESET} integration? (Y/n) "
        read responce
        case "$responce" in
            ''|[Yy]) ENABLE_GIT=1;;
            [Nn])    ENABLE_GIT=0;;
            *) continue;;
        esac
        break
    done

    while true; do
        printf "Show commands' ${LIGHT_GREEN}execution time${RESET}? (Y/n) "
        read responce
        case "$responce" in
            ''|[Yy]) SHOW_EXEC_TIME=1;;
            [Nn])    SHOW_EXEC_TIME=0;;
            *) continue;;
        esac
        break
    done
fi

# --- Outputing ---
. "$MODULES/os-info.sh"
case "$OS_COLOR_RGB" in (''|[!0-9]*) OS_COLOR_RGB="'$OS_COLOR_RGB'";; esac
case "$OS_COLOR_XTERM" in (''|[!0-9]*) OS_COLOR_XTERM="'$OS_COLOR_XTERM'";; esac
case "$OS_COLOR_BASE16" in (''|[!0-9]*) OS_COLOR_BASE16="'$OS_COLOR_BASE16'";; esac

. "$MODULES/escaping.sh"
cat > "$CONFIG" << EOF
#!/usr/bin/env sh
# Configuration file for LolPopGames' Zsh complex config

# Enviroment
DIR="$(shell_escape_quote "$DIR")"
MODULES="\$DIR/../../modules"
SRC="$(shell_escape_quote "$SRC")"
OUTPUT_DIR="$(shell_escape_quote "$OUTPUT_DIR")"

# System Stats
OS_NAME='$OS_NAME'${LINUX_FAMILY_BRANCH:+"
LINUX_FAMILY_BRANCH='$LINUX_FAMILY_BRANCH'"}
OS_ICON=''
OS_COLOR_RGB='#1793d1'
OS_COLOR_XTERM=32
OS_COLOR_BASE16='cyan'

# Add shortcut, that will add 'sudo' to any command runned with
# ctrl+enter instead of just enter (preconfigurated kitty is needed)
ADD_SUDO_SHORTCUT=$ADD_SUDO_SHORTCUT

# Prompt style:
#   'colorful' - Colorful
#   'bash' - Bash-like
#   'minimal' - Minimal
PROMPT_STYLE='$PROMPT_STYLE'
if [ "\$PROMPT_STYLE" = 'bash' ]; then
    # Prompt sign ($ or #):
    #   'bash' - Bash-like ($/#)
    #   'zsh' - Zsh-like (%/#)
    PROMPT_SIGN='$PROMPT_SIGN'
elif [ "\$PROMPT_STYLE" = 'colorful' ]; then
    # Char set:
    #   'nerdfonts' - UTF-8 with Nerd Fonts
    #   'utf-8' - UTF-8
    #   'ascii' - ASCII
    CHAR_SET='$CHAR_SET'
    # Color pallete:
    #   'truecolor' - True color (full RGB)
    #   'xterm256' - XTerm256
    #   'base16' - Base16
    COLOR_SET='$COLOR_SET'

    # Enables Android's battery level integration
    SHOW_BATTERY_LEVEL=$SHOW_BATTERY_LEVEL
    if [ "\$SHOW_BATTERY_LEVEL" -eq 1 ]; then
        # The minimum green and yellow battery level
        # (red minimum battery level is always 1)
        BATTERY_LEVEL_GREEN=$BATTERY_LEVEL_GREEN
        BATTERY_LEVEL_YELLOW=$BATTERY_LEVEL_YELLOW
    fi

    # Adds a newline before prompt only when not at the start of the screen
    MAKE_NEWLINE_IF_NEEDED=$MAKE_NEWLINE_IF_NEEDED
    # Manage dir icon depending on current direcotry
    # Automatically disables with ASCII charset
    MANAGE_DIR_ICON=$MANAGE_DIR_ICON
    # Enables git integration
    ENABLE_GIT=$ENABLE_GIT
    # Shows command execution time
    SHOW_EXEC_TIME=$SHOW_EXEC_TIME
fi
EOF
