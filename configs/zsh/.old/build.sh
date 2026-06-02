#!/usr/bin/env sh

SRC="${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles/zsh/src"

mark_prompt_sign() {
    case "$PROMPT_SIGN" in
        bash) printf '%(#.#.$)';;
        zsh) printf '%#';;
    esac
}

mark_newline() {
    if [ "$MAKE_NEWLINE_IF_NEEDED" -ne 1 ] || [ "$ENABLE_HOOKS" -ne 1 ]; then
        printf '\n'
    fi
}

mark_system() {
    printf '%s' '%F{'
    case "$COLOR_SET" in
        truecolor) printf '%s' "$OS_COLOR_RGB";;
        xterm256) printf '%s' "$OS_COLOR_XTERM";;
        base16) printf '%s' "$OS_COLOR_BASE16";;
    esac

    printf '%s' '}['

    case "$CHAR_SET" in
        nerdfonts) printf "$OS_LOGO";;
        utf-8) printf "$OS
    esac

    case "$OS_NAME" in
        linux-*)
            prompt_os_name="${OS_NAME#linux-}"
            case "$prompt_os_name" in
                arch) prompt_os_name='archlinux';;
                ldme) prompt_os_name='linuxmint';;
            esac;;
        android-*) prompt_os_name='android';;
        macos) prompt_os_name='macos';;
        windows-*) prompt_os_name='windows';;
        *) prompt_os_name='%m';;
    esac

    printf '%s' "$prompt_os_name"
}

mark_user() {
    case "$CHAR_SET" in
        nerdfonts) printf '%s' '
    esac
}

mark_prompt() {
    case "$PROMPT_STYLE" in
        minimal) cat "$SRC/prompt/minimal.zsh";;
        bash) mark_parse "$SRC/prompt/bash.zsh";;
        colorful) mark_parse "$SRC/prompt/colorful/colorful.zsh";;
    esac
}

parse_marks "$SRC/main.zsh"
