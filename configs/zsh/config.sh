#!/usr/bin/env sh
# Configuration file for LolPopGames' Zsh complex config

# Output directory
OUTPUT_DIR="${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh"

# Add shortcut, that will add 'sudo' to any command runned with
# ctrl+enter instead of just enter (preconfigurated kitty is needed)
ADD_SUDO_SHORTCUT=1

# Prompt style:
#   'colorful' - Colorful
#   'bash' - Bash-like
#   'minimal' - Minimal
PROMPT_STYLE='colorful'
if [ "$PROMPT_STYLE" = 'bash' ]; then
    # Prompt sign ($ or #):
    #   'bash' - Bash-like ($/#)
    #   'zsh' - Zsh-like (%/#)
    PROMPT_SIGN='bash'
elif [ "$PROMPT_STYLE" = 'colorful' ]; then
    # Char set:
    #   'nerdfonts' - UTF-8 with Nerd Fonts
    #   'emoji' - UTF-8 with emoji
    #   'utf-8' - UTF-8
    #   'ascii' - ASCII
    CHAR_SET='nerdfonts'
    # Color pallete:
    #   'truecolor' - True color (full RGB)
    #   'xterm256' - XTerm256
    #   'base16' - Base16
    COLOR_SET='truecolor'

    # Enables Android's battery level integration
    SHOW_BATTERY_LEVEL=0
    if [ "$SHOW_BATTERY_LEVEL" -eq 1 ]; then
        # The minimum green and yellow battery level
        # (red minimum battery level is always 1)
        BATTERY_LEVEL_GREEN=60
        BATTERY_LEVEL_YELLOW=20
    fi

    # Adds a newline before prompt only when not at the start of the screen
    MAKE_NEWLINE_IF_NEEDED=1
    # Manage dir icon depending on current direcotry
    # Automatically disables with ASCII charset
    MANAGE_DIR_ICON=1
    # Enables git integration
    ENABLE_GIT=1
    # Shows command execution time
    SHOW_EXEC_TIME=1
fi
