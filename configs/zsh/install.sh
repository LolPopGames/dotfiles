#!/usr/bin/env sh

CONFHOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

# --- Config ---
DIR="$(dirname "$(readlink -m "$0")")"
CONFIG="$DIR/config.sh"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
cat >&2 << EOF
config.sh: File not found
Generate config.sh with %s
EOF
    exit 1
fi

mark_PROMPT_SUBST() {
    if [ "$PROMPT_STYLE" = colorful ]; then
        printf ' PROMPT_SUBST'
    fi
}

. "$MODULES/escaping.sh"
mark_dot_path() {
    shell_escape_quote "$(realpath -ms "$DIR/../..")"
}

mark_sudo() {
    if [ "$ADD_SUDO_SHORTCUT" -eq 1 ]; then
        cat "$SRC/sudo.zsh"
    fi
}

mark_prompt() {
    case "$PROMPT_STYLE" in
        bash)     parse_marks "$SRC/prompt/bash.zsh";;
        minimal)  cat         "$SRC/prompt/minimal.zsh";;
        colorful) parse_marks "$SRC/prompt/colorful/colorful.zsh";;
        *)
            printf '%s: Unknown prompt style: %s' "$0" "$PROMPT_STYLE" >&2
            exit 1;;
    esac
}

mark_bash_sign() {
    case "$PROMPT_SIGN" in
        bash) printf '%s' '%(#.#.$)';;
        zsh)  printf '%s' '%#';;
        *)
            printf '%s: Unknown prompt sign type: %s' "$0" "$PROMPT_SIGN" >&2
            exit 1;;
    esac
}

mark_colorful_newline() {
    if [ "$MAKE_NEWLINE_IF_NEEDED" -eq 0 ]; then
        printf '\n'
    fi
}

mark_colorful_system() {
    case "$COLOR_SET" in
        truecolor) printf '%s' "%F{$OS_COLOR_RGB}";;
        xterm256)  printf '%s' "%F{$OS_COLOR_XTERM}";;
        base16)    printf '%s' "%F{$OS_COLOR_BASE16}";;
        *)
            printf "%s: Unknown color set: %s" "$0" "$COLOR_SET" >&2
            exit 1;;
    esac
    printf '['
    case "$CHAR_SET" in
        nerdfonts) printf '%s' "$OS_ICON";;
        utf-8)     printf '%s' '🖥';;
        ascii)     printf '%s' '@';;
        *)
            printf "%s: Unknown char set: %s" "$0" "$CHAR_SET" >&2
            exit 1;;
    esac
    printf '%s' '] '
    case "$OS_NAME" in
        linux-*)
            case "$OS_NAME" in
                linux-arch) os_name='archlinux';;
                linux-ldme) os_name='linuxmint';;
                rhel)       os_name='redhat';;
                ol)         os_name='oraclelinux';;
                cachy)      os_name='cachyos';;
                void)       os_name='voidlinux';;
                *)          os_name="${OS_NAME#linux-}";;
            esac;;
        android-*)  os_name='android';;
        windows-*)  os_name='windows';;
        macos)      os_name='macos';;
        unknown)    os_name='%m';;
        *)          os_name="$OS_NAME";;
    esac
    printf '%s' "$os_name%f"
}

mark_colorful_user_char() {
    case "$CHAR_SET" in
        nerdfonts) printf '%s' "";;
        utf-8)     printf '%b' "👤%{\uFE0E%}";;
        ascii)     printf '%s' "%#";;
    esac
}

mark_colorful_dir_icon() {
    case "$CHAR_SET" in
        nerdfonts)
            if [ "$MANAGE_DIR_ICON" -eq 1 ]; then
                printf '$dir_icon'
            else
                printf '󰝰'
            fi;;
        utf-8)
            if [ "$MANAGE_DIR_ICON" -eq 1 ]; then
                printf '$dir_icon'
            else
                printf '🖿'
            fi;;
        ascii) printf '/';;
    esac
}

mark_colorful_git() {
    if [ "$ENABLE_GIT" -eq 1 ]; then
        printf ' $git_text'
    fi }

mark_colorful_exitcode_char() {
    case "$CHAR_SET" in
        nerdfonts|utf-8)
            # Checking for Mintty because a non-ASCII in RPROMPT brokes shell
            if [ "$(basename "$(ps -p "$PPID" -o comm | tail -n 1)")" = 'mintty' ]; then
                printf '<'
                return 0
            fi
            printf '↵';;
        ascii) printf '<';;
    esac
}

mark_colorful_exec_time() {
    if [ "$SHOW_EXEC_TIME" -eq 1 ]; then
        printf '${exec_time_text}'
    fi
}

mark_colorful_job_char() {
    case "$CHAR_SET" in
        nerdfonts)
            # Checking for Mintty because a non-ASCII in RPROMPT brokes shell
            if [ "$(basename "$(ps -p "$PPID" -o comm | tail -n 1)")" = 'mintty' ]; then
                printf '*'
                return 0
            fi
            printf '';;
        utf-8)
            # Checking for Mintty because a non-ASCII in RPROMPT brokes shell
            if [ "$(basename "$(ps -p "$PPID" -o comm | tail -n 1)")" = 'mintty' ]; then
                printf '*'
                return 0
            fi
            printf '⚙';;
        ascii) printf '*';;
    esac
}

mark_coloful_PROMPT4() {
    case "$COLOR_SET" in
        truecolor|xterm256) printf '%s' '%F{166}';;
        base16)             printf '%s' '%F{red}';;
    esac
    printf '['
    case "$CHAR_SET" in
        nerdfonts) printf '󰃤';;
        utf-8)     printf '🐞';;
        ascii)     printf '#';;
    esac
    printf '] '
    case "$COLOR_SET" in
        truecolor|xterm256) printf '%s' '%F{168}';;
        base16)             printf '%s' '%F{8}';;
    esac
    printf '(%i)%f '
}

mark_colorful_preexec() {
    if [ "$SHOW_EXEC_TIME" -eq 1 ]; then
        parse_marks "$SRC/prompt/colorful/preexec.zsh"
    fi
}

mark_colorful_preexec_exec_time() {
    if [ "$SHOW_EXEC_TIME" -eq 1 ]; then
        cat "$SRC/prompt/colorful/exec-time/preexec.zsh"
    fi
}

mark_colorful_precmd() {
    if [ "$MAKE_NEWLINE_IF_NEEDED" -eq 1 ] ||
       [ "$MANAGE_DIR_ICON"        -eq 1 ] ||
       [ "$ENABLE_GIT"             -eq 1 ] ||
       [ "$SHOW_EXEC_TIME"         -eq 1 ]; then
        parse_marks "$SRC/prompt/colorful/precmd.zsh"
    fi
}

mark_colorful_precmd_exec_time() {
    if [ "$SHOW_EXEC_TIME" -eq 1 ]; then
        parse_marks "$SRC/prompt/colorful/exec-time/precmd.zsh"
    fi
}

mark_colorful_exec_time_colors() {
    case "$COLOR_SET" in
        truecolor) printf '#d1be0d.99';;
        xterm256)  printf '178.99';;
        base16)    printf 'yellow.magenta';;
    esac
}

mark_colorful_exec_time_chars() {
    case "$CHAR_SET" in
        nerdfonts)
            # Checking for Mintty because a non-ASCII in RPROMPT brokes shell
            if [ "$(basename "$(ps -p "$PPID" -o comm | tail -n 1)")" = 'mintty' ]; then
                printf '~'
                return 0
            fi
            printf '%s' '%(?.󱎫.󱎬)';;
        utf-8)
            # Checking for Mintty because a non-ASCII in RPROMPT brokes shell
            if [ "$(basename "$(ps -p "$PPID" -o comm | tail -n 1)")" = 'mintty' ]; then
                printf '~'
                return 0
            fi
            printf '⏱';;
        ascii) printf '~';;
    esac
}

mark_colorful_precmd_newline_if_needed() {
    if [ "$MAKE_NEWLINE_IF_NEEDED" -eq 1 ]; then
        cat "$SRC/prompt/colorful/newline-if-needed.zsh"
    fi
}

mark_colorful_precmd_dir_icon() {
    if [ "$MANAGE_DIR_ICON" -eq 1 ] && [ "$CHAR_SET" != 'ascii' ]; then
        parse_marks "$SRC/prompt/colorful/dir-icon.zsh"
    fi
}

mark_colorful_dir_icon_char() {
    case "$CHAR_SET" in
        nerdfonts)
            case "$1" in
                home)       printf '';;
                code)       printf '';;
                music)      printf '';;
                documents)  printf '󰈙';;
                downloads)  printf '󰜮';;
                desktop)    printf '󰇄';;
                pictures)   printf '';;
                videos)     printf '';;
                config)     printf '';;
                root)       printf '󱛟';;
                usr)        printf '';;
                locked)     printf '󰌾';;
                hidden)     printf '󱞞';;
                empty)      printf '󰷏';;
                default)    printf '󰝰';;
            esac;;
        utf-8)
            case "$1" in
                home)       printf '🏠︎';;
                code)       printf '⌨️';;
                music)      printf '🎵︎';;
                documents)  printf '📄';;
                downloads)  printf '⬇';;
                desktop)    printf '💻︎';;
                pictures)   printf '🖼️';;
                videos)     printf '🎬';;
                config)     printf '⚙';;
                root)       printf '💽';;
                usr)        printf '🛠️';;
                locked)     printf '🔒';;
                hidden)     printf '🖿';;
                empty)      printf '🗁';;
                default)    printf '🗁';;
            esac;;
    esac
}

mark_colorful_precmd_git() {
    if [ "$ENABLE_GIT" -eq 1 ]; then
        parse_marks "$SRC/prompt/colorful/git/git.zsh"
    fi
}

mark_colorful_git_remote() {
    case "$CHAR_SET" in
        nerdfonts) cat "$SRC/prompt/colorful/git/remote-nerdfonts.zsh";;
        utf-8)     printf "remote_icon=' 🌐︎'";;
        ascii)     printf "remote_icon=' @'";;
    esac
}

mark_colorful_git_char() {
    case "$CHAR_SET" in
        nerdfonts)
            case "$1" in
                logo) printf '󰊢';;
                staged) printf '';;
                deleted) printf '';;
                renamed) printf '';;
                modified) printf '󰏫';;
                untracked) printf '';;
                unmerged) printf '󱐋';;
                stash) printf '';;
            esac;;
        utf-8)
            case "$1" in
                logo) printf '⎇';;
                staged) printf '✓';;
                deleted) printf '✗';;
                renamed) printf '↺';;
                modified) printf '✎';;
                untracked) printf '⍰';;
                unmerged) printf '⚡︎';;
                stash) printf '▣';;
            esac;;
        ascii)
            case "$1" in
                logo) printf 'g';;
                staged) printf '+';;
                deleted) printf 'x';;
                renamed) printf '>';;
                modified) printf '!';;
                untracked) printf '?';;
                unmerged) printf '*';;
                stash) printf '#';;
            esac;;
    esac
}

OUTPUT="$OUTPUT_DIR/.zshrc"
. "$MODULES/marks.sh"
parse_marks "$SRC/main.zsh" > "$OUTPUT"

if [ "$OUTPUT" != "$HOME/.zshrc" ]; then
cat >> "$HOME/.zshrc" << EOF
ZDOTDIR="\${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh" zsh --login
EOF
fi

if [ -n "$ZSH_VERSION" ]; then
    zcompile "$OUTPUT"
    [ "$OUTPUT" != "$HOME/.zshrc" ] && zcompile "$HOME/.zshrc"
elif command -v zsh >/dev/null 2>&1; then
    zsh -c -- "zcompile \"$(shell_escape_quote "$OUTPUT")\""
    [ "$OUTPUT" != "$HOME/.zshrc" ] && zsh -c -- "zcompile \"$(shell_escape_quote "$HOME/.zshrc")\""
fi
