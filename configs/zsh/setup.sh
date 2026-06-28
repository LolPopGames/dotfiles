#!/usr/bin/env sh
. "$(dirname "$(readlink -m "$0")")/../../modules/preloaded/preloaded.sh"

add_dep zsh

# --- Getting Information ---
if ask_yesno "Add sudo shortcut for ${LIGHT_GREEN}ctrl+enter${RESET} (preconfigured kitty is needed)" y; then
    ADD_SUDO_SHORTCUT=1
else
    ADD_SUDO_SHORTCUT=0
fi

case "$(ask_choice "Which ${LIGHT_GREEN}theme${RESET} to use" colorful bash minimal)" in
    colorful) PROMPT_STYLE='colorful';;
    bash)     PROMPT_STYLE='bash';;
    minimal)  PROMPT_STYLE='minimal';;
esac

if [ "$PROMPT_STYLE" != 'bash' ]; then
    PROMPT_SIGN='bash'
else
    case "$(ask_choice "Which type of ${LIGHT_GREEN}prompt sign${RESET} ($/#) to use" bash zsh)" in
        bash) PROMPT_SIGN='bash';;
        zsh)  PROMPT_SIGN='zsh';;
    esac
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
    case "$(ask_choice "Which ${LIGHT_GREEN}char set${RESET} to use" nerdfonts utf-8 ascii)" in
        nerdfonts) CHAR_SET='nerdfonts';;
        utf-8)     CHAR_SET='utf-8';;
        ascii)     CHAR_SET='ascii';;
    esac

    if [ "$CHAR_SET" = 'ascii' ]; then
        case "$(ask_choice "Which ${LIGHT_GREEN}color set${RESET} to use" base16 xterm256 truecolor)" in
            base16)    COLOR_SET='base16';;
            xterm256)  COLOR_SET='xterm256';;
            truecolor) COLOR_SET='truecolor';;
        esac
    else
        case "$(ask_choice "Which ${LIGHT_GREEN}color set${RESET} to use" truecolor xterm256 base16)" in
            truecolor) COLOR_SET='truecolor';;
            xterm256)  COLOR_SET='xterm256';;
            base16)    COLOR_SET='base16';;
        esac
    fi

    case "$OS_NAME" in
        android-*)
            if ask_yesno "Show Android's ${LIGHT_GREEN}battery level${RESET}" y; then
                SHOW_BATTERY_LEVEL=1
            else
                SHOW_BATTERY_LEVEL=0
            fi;;
        *)
            if ask_yesno "Show Android's ${LIGHT_RED}battery level${RESET}" n; then
                SHOW_BATTERY_LEVEL=1
            else
                SHOW_BATTERY_LEVEL=0
            fi;;
    esac

    if [ "$SHOW_BATTERY_LEVEL" -eq 0 ]; then
        BATTERY_LEVEL_GREEN=60
        BATTERY_LEVEL_YELLOW=20
    else
        add_optdep jq

        while true; do
            printf "${INDENT:+"${LIGHT_GREEN}=>${RESET} "}What will be minimal ${LIGHT_GREEN}green${RESET} battery level (from X up to 100%%)? (${BOLD}60%%${RESET}) "
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
            printf "${INDENT:+"${LIGHT_YELLOW}=>${RESET} "}What will be minimal ${LIGHT_YELLOW}yellow${RESET} battery level (from X up to $maxiumum%%)? (${BOLD}$recommended%%${RESET}) "
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
    fi

    if [ "$CHAR_SET" = 'ascii' ]; then
        if ask_yesno "Make ${LIGHT_RED}newline${RESET} if needed" n; then
            MAKE_NEWLINE_IF_NEEDED=1
        else
            MAKE_NEWLINE_IF_NEEDED=0
        fi
    else
        if ask_yesno "Make ${LIGHT_GREEN}newline${RESET} if needed" y; then
            MAKE_NEWLINE_IF_NEEDED=1
        else
            MAKE_NEWLINE_IF_NEEDED=0
        fi
    fi

    if [ "$CHAR_SET" = 'ascii' ]; then
        if ask_yesno "Manage ${LIGHT_RED}dir icon${RESET}" n; then
            MANAGE_DIR_ICON=1
        else
            MANAGE_DIR_ICON=0
        fi
    else
        if ask_yesno "Manage ${LIGHT_GREEN}dir icon${RESET}" y; then
            MANAGE_DIR_ICON=1
        else
            MANAGE_DIR_ICON=0
        fi
    fi

    if ask_yesno "Enable ${LIGHT_GREEN}git${RESET} integration" y; then
        ENABLE_GIT=1
    else
        ENABLE_GIT=0
    fi

    if ask_yesno "Show commands' ${LIGHT_GREEN}execution time${RESET}" y; then
        SHOW_EXEC_TIME=1
    else
        SHOW_EXEC_TIME=0
    fi
fi

# --- Outputing ---
cat >> "$CONFIG" << EOF
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

output_deps
