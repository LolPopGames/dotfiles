# vim: set foldmethod=indent:

# Environment:
# 'oh-my-zsh' - Oh-My-Zsh
# 'custom' - Custom Configuration
ENVIRONMENT='custom'
if [[ "$ENVIRONMENT" == 'custom' ]]; then
    # Prompt Style:
    # 'bash' - Bash-like
    # 'minimal' - Minimal
    # 'colorful' - Colorful
    PROMPT_STYLE='colorful'
    if [[ "$PROMPT_STYLE" == 'bash' ]]; then
        # Prompt Sign:
        # 'bash' - Bash-like
        # 'zsh' - Zsh-like
        PROMPT_SIGN='bash'

    elif [[ "$PROMPT_STYLE" == 'colorful' ]]; then
        # Character Set:
        # 'truetype' - TrueType
        # 'tty' - TeleType Writer (Linux without GUI)
        CHAR_SET='truetype'
        # Color Set:
        # 'truecolor' - 24 Bit Color Pallete
        # 'xterm256' - xterm 256 Colors
        # 'base16' - Basic 16 Colors
        COLOR_SET='truecolor'
        # Enable Hooks
        ENABLE_HOOKS=1
        if (( ENABLE_HOOKS )); then
            # Show Execution Time
            SHOW_EXEC_TIME=1
            # Make Newline If Needed
            MAKE_NEWLINE_IF_NEEDED=1
            # Manage Dir Icons
            MANAGE_DIR_ICONS=1
            # Enable Git
            ENABLE_GIT=1
        fi
        # Use Original OS Logo Color
        USE_ORIGINAL_OS_LOGO_COLOR=1
    fi
fi
