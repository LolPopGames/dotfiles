#!/usr/bin/env zsh
set -e

# Custom Config Directory
SRC="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/zsh/src"

# Output File
OUTPUT="${ZDOTDIR:-$HOME}/.zshrc"
mkdir -p "${ZDOTDIR:-$HOME}"

# Loading Config
source "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/zsh/config.zsh"

# Getting OS color and logo
OS="$(uname -o)"
if [[ "$OS" == 'Android' ]]; then
    OS_NAME='android'
else # GNU/Linux
    OS_NAME="$(sed -En 's/^ID=//p' /etc/os-release)" 
fi
case "$OS_NAME" in
    debian|peppermint|neptune|bunsenlabs|antix|crunchbangplusplus|sparky|whonix|pureos|q4os|endless) OS_COLOR_RGB='#a7002e' OS_COLOR_XTERM=124 OS_COLOR_BASE16='red' OS_ICON_TRUETYPE='';;
    ubuntu|ubuntu-mate|ubuntu-budgie|xubuntu|lubuntu|ubuntu-studio|feren|voyager|ubuntu-kylin|tuxedo|caine|backbox) OS_COLOR='#ea5516' OS_COLOR_XTERM=166 OS_COLOR_BASE16=9 OS_ICON='';;
    linuxmint|ldme) OS_COLOR='#6eb745' OS_COLOR_XTERM=71 OS_COLOR_BASE16=10 OS_ICON='';;
    elementary) OS_COLOR='#4aa5e9' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='';;
    pop) OS_COLOR='#48b9c7' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='';;
    kali) OS_COLOR='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON='';;
    parrot) OS_COLOR='#16e6f2' OS_COLOR_XTERM=45 OS_COLOR_BASE16=14 OS_ICON='';;
    zorin) OS_COLOR='#15a6f0' OS_COLOR_XTERM=39 OS_COLOR_BASE16=12 OS_ICON='';;
    deepin) OS_COLOR='#33c5ff' OS_COLOR_XTERM=81 OS_COLOR_BASE16=14 OS_ICON='';;
    mx|avlinux) OS_COLOR='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON='';;
    kubuntu) OS_COLOR='#087dc3' OS_COLOR_XTERM=31 OS_COLOR_BASE16='blue' OS_ICON='';;
    devuan) OS_COLOR='#494857' OS_COLOR_XTERM=239 OS_COLOR_BASE16=8 OS_ICON='';;
    tails) OS_COLOR='#5b3a80' OS_COLOR_XTERM=60 OS_COLOR_BASE16='magenta' OS_ICON='';;
    fedora|amzn|nst|fedora-coreos) OS_COLOR='#56a5db' OS_COLOR_XTERM=74 OS_COLOR_BASE16=12 OS_ICON='';;
    rhel|ol|scientific|eurolinux|miraclelinux|navylinux|virtuozzo) OS_COLOR='#cf0808' OS_COLOR_XTERM=160 OS_COLOR_BASE16='red' OS_ICON='';;
    centos|clearos) OS_COLOR='#f0aa2b' OS_COLOR_XTERM=214 OS_COLOR_BASE16='yellow' OS_ICON='';;
    rocky) OS_COLOR='#17bb85' OS_COLOR_XTERM=36 OS_COLOR_BASE16=10 OS_ICON='';;
    almalinux) OS_COLOR='#ff4c4f' OS_COLOR_XTERM=203 OS_COLOR_BASE16=9 OS_ICON='';;
    arch|blackarch|archbang|rebornos|archman|chimera) OS_COLOR='#1793d1' OS_COLOR_XTERM=32 OS_COLOR_BASE16='cyan' OS_ICON='';;
    manjaro) OS_COLOR='#3bc161' OS_COLOR_XTERM=71 OS_COLOR_BASE16=10 OS_ICON='';;
    endeavouros) OS_COLOR='#8345c1' OS_COLOR_XTERM=97 OS_COLOR_BASE16=13 OS_ICON='';;
    garuda) OS_COLOR='#2fa7f2' OS_COLOR_XTERM=39 OS_COLOR_BASE16=14 OS_ICON='';;
    artix) OS_COLOR='#64bed9' OOS_COLOR_XTERM=74 OS_COLOR_BASE16=14 S_ICON='';;
    arcolinux) OS_COLOR='#6c93ec' OS_COLOR_XTERM=69 OS_COLOR_BASE16=12 OS_ICON='';;
    archcraft) OS_COLOR='#86bba6' OS_COLOR_XTERM=109 OS_COLOR_BASE16=10 OS_ICON='';;
    archlabs) OS_COLOR='#363637' OS_COLOR_XTERM=237 OS_COLOR_BASE16=0 OS_ICON='';;
    opensuse-tumbleweed|geckolinux|opensuse-microos) OS_COLOR='#77bc2c' OS_COLOR_XTERM=106 OS_COLOR_BASE16='green' OS_ICON='';;
    opensuse-leap|sles) OS_COLOR='#69b54b' OS_COLOR_XTERM=71 OS_COLOR_BASE16='green' OS_ICON='';;
    gentoo|calculate|redcore) OS_COLOR='#9c94da' OS_COLOR_XTERM=140 OS_COLOR_BASE16=12 OS_ICON='';;
    sabayon) OS_COLOR='#3c464b' OS_COLOR_XTERM=238 OS_COLOR_BASE16=8 OS_ICON='';;
    chromeos) OS_COLOR='#e03d32' OS_COLOR_XTERM=167 OS_COLOR_BASE16=9 OS_ICON='';;
    alpine) OS_COLOR='#155e83' OS_COLOR_XTERM=24 OS_COLOR_BASE16='blue' OS_ICON='';;
    void) OS_COLOR='#4d8466' OS_COLOR_XTERM=65 OS_COLOR_BASE16='green' OS_ICON='';;
    nixos) OS_COLOR='#577cc5' OS_COLOR_XTERM=68 OS_COLOR_BASE16=12 OS_ICON='';;
    slakeware) OS_COLOR='#4f67b1' OS_COLOR_XTERM=61 OS_COLOR_BASE16=12 OS_ICON='';;
    solus) OS_COLOR='#525768' OS_COLOR_XTERM=240 OS_COLOR_BASE16=8 OS_ICON='';;
    mageia) OS_COLOR='#2d364b' OS_COLOR_XTERM=237 OS_COLOR_BASE16='black' OS_ICON='';;
    openmandriva|rosa) OS_COLOR='#42a4d8' OS_COLOR_XTERM=74 OS_COLOR_BASE16=14 OS_ICON='';;
    steamos) OS_COLOR='#ffffff' OS_COLOR_XTERM=15 OS_COLOR_BASE16=15 OS_ICON='';;
    obsd) OS_COLOR='#f2dc77' OS_COLOR_XTERM=222 OS_COLOR_BASE16=11 OS_ICON='';;
    qubes) OS_COLOR='#68a3ff' OS_COLOR_XTERM=75 OS_COLOR_BASE16=12 OS_ICON='';;
    coreos|flatcar) OS_COLOR='#58a6db' OS_COLOR_XTERM=74 OS_COLOR_BASE16=12 OS_ICON='';;
    android) OS_COLOR='#85c446' OS_COLOR_XTERM=113 OS_COLOR_BASE16='green' OS_ICON='󰀲';;
    *) OS_COLOR='#f7c017' OS_COLOR_XTERM=214 OS_COLOR_BASE16='yellow' OS_ICON='';;
esac

if (( !USE_ORIGINAL_OS_LOGO_COLOR )); then
    OS_COLOR=74
    OS_COLOR_XTERM=74
    OS_COLOR_BASE16='blue'
fi
[[ "$CHAR_SET" == 'tty' ]] && OS_ICON='@'

{
    file_content=
    if [[ "$ENVIRONMENT" == 'oh-my-zsh' ]]; then
        print -rn -- "$(<"$SRC/oh-my-zsh.zsh")"
    else
        print -rn -- "$(<"$SRC/custom.zsh")"

        if [[ "$PROMPT_STYLE" == 'bash' ]]; then
            if   [[ "$PROMPT_SIGN" == 'bash' ]]; then cat "$SRC/prompt/bash/bash-bash.zsh"
            elif [[ "$PROMPT_SIGN" == 'zsh'  ]]; then cat "$SRC/prompt/bash/bash-zsh.zsh"
            fi

        elif [[ "$PROMPT_STYLE" == 'minimal' ]]; then
            print -rn -- "$(<"$SRC/prompt/minimal.zsh")"

        elif [[ "$PROMPT_STYLE" == 'colorful' ]]; then
            print -rn -- "$(<"$SRC/prompt/colorful/base.zsh")"

            # Making PROMPT
            print -rn -- "$(<"$SRC/prompt/colorful/PROMPT/p1.zsh")"

            (( !MAKE_NEWLINE_IF_NEEDED )) && print -rn -- $'\n'

            print -rn -- '%F{'

            if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- "$OS_COLOR"
            elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- "$OS_COLOR_XTERM"
            elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- "$OS_COLOR_BASE16"
            fi

            print -rn -- "}[$OS_ICON] %m %F{white}["

            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- ''
            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- '%#'
            fi

            print -rn -- '] %n %F{blue}['

            if   [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- '/'
            elif [[ "$CHAR_SET" == 'truetype' ]]; then
                if (( MANAGE_DIR_ICONS )); then
                    print -rn -- '${dir_icon}'
                else
                    print -rn -- '󰝰'
                fi
            fi

            print -rn -- '] %~'
            
            if (( ENABLE_GIT )); then
                print -r -- ' ${git_text}'
            else
                print -r -- '%f'
            fi

            print -rn -- "$(<"$SRC/prompt/colorful/PROMPT/p2.zsh")"

            # Making RPROMPT

            print -rn -- "$(<"$SRC/prompt/colorful/RPROMPT/p1.zsh")"

            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- '↵ '
            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- '< '
            fi

            (( SHOW_EXEC_TIME )) && print -rn -- '${exec_time_text}'

            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -r -- "$(<"$SRC/prompt/colorful/RPROMPT/p2.zsh")"
            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -r -- "$(<"$SRC/prompt/colorful/RPROMPT/p2-tty.zsh")"
            fi

            # Making Hooks
            if (( ENABLE_HOOKS )); then
                (( SHOW_EXEC_TIME )) && print -r -- "$(<"$SRC/prompt/colorful/exec-time-preexec.zsh")"

                print -rn -- $'precmd() {\n'

                if (( SHOW_EXEC_TIME )) && print -r -- "$(<"$SRC/prompt/colorful/exec-time-precmd/p1.zsh")"
                
                if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- "exec_time_text='%F{%(?.#d1be0d.99)}"
                elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- "exec_time_text='%F{%(?.178.99)}"
                elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- "exec_time_text='%F{%(?.yellow.magenta)}"
                fi

                if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- "%(?.󱎫.󱎬) '"
                elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- "~ '"
                fi

                print -r -- "$(<"$SRC/prompt/colorful/exec-time-precmd/p2.zsh")"

                (( MAKE_NEWLINE_IF_NEEDED )) && print -r -- "$(<"$SRC/prompt/colorful/make-newline-if-needed.zsh")"
                (( MANAGE_DIR_ICONS )) && [[ "$CHAR_SET" == 'truetype' ]] && print -r -- "$(<"$SRC/prompt/colorful/dir-icon.zsh")"

                if (( ENABLE_GIT )); then
                    print -rn -- "$(<"$SRC/prompt/colorful/git/p1.zsh")"

                    if   [[ "$CHAR_SET" == 'truetype' ]]; then print -r -- "$(<"$SRC/prompt/colorful/git/p2.zsh")"
                    elif [[ "$CHAR_SET" == 'tty'      ]]; then print -r -- "$(<"$SRC/prompt/colorful/git/p2-tty.zsh")"
                    fi

                    if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- 'git_text="%F{166}'
                    elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- 'git_text="%F{166}'
                    elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- 'git_text="%F{yellow}'
                    fi

                    if   [[ "$CHAR_SET" == 'truetype' ]]; then print -r -- '[󰊢$git__remote_icon] $git__branch_tag_location"'
                    elif [[ "$CHAR_SET" == 'tty'      ]]; then print -r -- '[g$git__remote_icon] $git__branch_tag_location"'
                    fi

                    print -rn -- "$(<"$SRC/prompt/colorful/git/p3.zsh")"


                    print -rn -- '[[ -f "$git__gitdir/logs/refs/stash" ]] && () { git_text+="'

                    if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- '󰗉'
                    elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- '='
                    fi

                    print -r -- '$#" } ${(f)"$(<$git__gitdir/logs/refs/stash)"}'

                    print -r -- "$(<"$SRC/prompt/colorful/git/p4.zsh")"
                fi

                print -r -- '}'
            fi
        fi

        #elif [[ "$PROMPT_STYLE" == 'bettercolorful' ]]; then
        #    print -rn -- "$(<"$SRC/prompt/bettercolorful/base.zsh")"

        #    # Making PROMPT
        #    print -rn -- "$(<"$SRC/prompt/bettercolorful/PROMPT/p1.zsh")"

        #    (( !MAKE_NEWLINE_IF_NEEDED )) && print -rn -- $'\n'

        #    print -rn -- '%F{'

        #    if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- "$OS_COLOR"
        #    elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- "$OS_COLOR_XTERM"
        #    elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- "$OS_COLOR_BASE16"
        #    fi

        #    print -rn -- "}[$OS_ICON] "
        #    print -r -- "$(<"$SRC/prompt/bettercolorful/PROMPT/p2.zsh")"

        #    # Making Hooks
        #    if (( ENABLE_HOOKS )); then
        #        (( SHOW_EXEC_TIME )) && print -r -- "$(<"$SRC/prompt/bettercolorful/exec-time-preexec.zsh")"

        #        print -rn -- $'precmd() {\n'

        #        if (( SHOW_EXEC_TIME )) && print -r -- "$(<"$SRC/prompt/bettercolorful/exec-time-precmd/p1.zsh")"
        #        
        #        if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- "exec_time_text='%F{%(?.#d1be0d.99)}"
        #        elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- "exec_time_text='%F{%(?.178.99)}"
        #        elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- "exec_time_text='%F{%(?.yellow.magenta)}"
        #        fi

        #        if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- "%(?.󱎫.󱎬) '"
        #        elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- "~ '"
        #        fi

        #        print -r -- "$(<"$SRC/prompt/bettercolorful/exec-time-precmd/p2.zsh")"

        #        (( MAKE_NEWLINE_IF_NEEDED )) && print -r -- "$(<"$SRC/prompt/bettercolorful/make-newline-if-needed.zsh")"
        #        (( MANAGE_DIR_ICONS )) && [[ "$CHAR_SET" == 'truetype' ]] && print -r -- "$(<"$SRC/prompt/bettercolorful/dir-icon.zsh")"

        #        if (( ENABLE_GIT )); then
        #            print -rn -- "$(<"$SRC/prompt/bettercolorful/git/p1.zsh")"

        #            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -r -- "$(<"$SRC/prompt/bettercolorful/git/p2.zsh")"
        #            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -r -- "$(<"$SRC/prompt/bettercolorful/git/p2-tty.zsh")"
        #            fi

        #            if   [[ "$COLOR_SET" == 'truecolor' ]]; then print -rn -- 'git_text="%F{166}'
        #            elif [[ "$COLOR_SET" == 'xterm256'  ]]; then print -rn -- 'git_text="%F{166}'
        #            elif [[ "$COLOR_SET" == 'base16'    ]]; then print -rn -- 'git_text="%F{yellow}'
        #            fi

        #            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -r -- '[󰊢$git__remote_icon] $git__branch_tag_location"'
        #            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -r -- '[g$git__remote_icon] $git__branch_tag_location"'
        #            fi

        #            print -rn -- "$(<"$SRC/prompt/bettercolorful/git/p3.zsh")"


        #            print -rn -- '[[ -f "$git__gitdir/logs/refs/stash" ]] && () { git_text+="'

        #            if   [[ "$CHAR_SET" == 'truetype' ]]; then print -rn -- '󰗉'
        #            elif [[ "$CHAR_SET" == 'tty'      ]]; then print -rn -- '='
        #            fi

        #            print -r -- '$#" } ${(f)"$(<$git__gitdir/logs/refs/stash)"}'

        #            print -r -- "$(<"$SRC/prompt/bettercolorful/git/p4.zsh")"
        #        fi

        #        # Making Prompt Manager


        #        print -r -- '}'
        #    fi
        #fi
    fi
} > "$OUTPUT"

zcompile "$OUTPUT"
[[ -n "$ZDOTDIR" ]] && ln -f -s "$ZDOTDIR"/{.zshrc,zshrc}
