# vim: set foldmethod=indent:

# Prompt Style:
# 'bash' - Bash-like
# 'minimal' - Minimal
# 'colorful' - Colorful
PROMPT_STYLE='colorful'
if [ "$PROMPT_STYLE" = 'bash' ]; then
    # Prompt Sign:
    # 'bash' - Bash-like
    # 'zsh' - Zsh-like
    PROMPT_SIGN='bash'

elif [ "$PROMPT_STYLE" = 'colorful' ]; then
    # Character Set:
    # 'nerdfonts' - Nerd Fonts
    # 'emoji' - UTF-8 + Emojis
    # 'truetype' - TrueType (UTF-8)
    # 'ascii' - ASCII only
    CHAR_SET='nerdfonts'
    # Color Set:
    # 'truecolor' - 24 Bit Color Pallete
    # 'xterm256' - xterm 256 Colors
    # 'base16' - Basic 16 Colors
    COLOR_SET='truecolor'
    # Enable Hooks
    ENABLE_HOOKS=1
    if [ "$ENABLE_HOOKS" -eq 1 ]; then
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
