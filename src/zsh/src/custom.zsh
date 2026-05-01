echo -n $'\e[5 q'
setopt AUTO_CD AUTO_PUSHD PUSHD_SILENT LIST_BEEP LIST_TYPES EXTENDED_GLOB NULL_GLOB HIST_IGNORE_DUPS SHARE_HISTORY INC_APPEND_HISTORY HIST_REDUCE_BLANKS APPEND_HISTORY INTERACTIVE_COMMENTS MULTIOS PIPE_FAIL CORRECT PROMPT_SUBST BEEP
alias e='exit' q='exit' :q='exit' ls='ls --color=auto -h' la='ls -a' ll='ls -al' lA='ls -A' lL='ls -Al' l='ls -A' clear='reset' cls='reset' c='reset' g='git' ga='git add' ga.='git add .' gc='git commit --verbose' gC='ga. && gc' gp='git push' gr='git remote' gl='git pull' gb='git branch' gco='git checkout' gs='git switch' grs='git restore' gst='git status' md='mkdir -p' p='poweroff' sudo='sudo ' s='sudo' _='sudo' grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}' egrep='grep -E' pacman='pacman --color=auto' paru='paru --color=auto' code='code-oss' clang-and9='/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang' clang-and9-x86='/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi28-clang' clang++-and9='/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang++' clang++-and9-x86='/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi28-clang++' ...='../..' ....='../../..' .....='../../../..' ......='../../../../..' .......='../../../../../..' ........='../../../../../../..' buildconf='${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/buildconf.sh' confconf='${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/confconf.sh' editconf='exec ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/editconf.sh' editbuild='${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/editbuild.sh'
dot() {
    git -C "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/repo" "$@"
}
bindkey '^[[Z' reverse-menu-complete
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[3;2~' delete-char
bindkey '^U' kill-buffer
bindkey '^[[H' beginning-of-line
bindkey '^[[1;2H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;2F' end-of-line
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[5~' up-line-or-beginning-search
bindkey '^[[5;2~' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[6~' down-line-or-beginning-search
bindkey '^[[6;2~' down-line-or-beginning-search
bindkey '^[[2~' overwrite-mode
bindkey '^[[2;2~' overwrite-mode
wrap-line() {
    LBUFFER+=$'\n'
}
zle -N wrap-line
bindkey '^O' wrap-line
typeset -g _LAST_WAS_EMPTY=1
_tracked-accept-line() {
    [[ -z "${BUFFER//[[:space:]]/}" ]] && _LAST_WAS_EMPTY=1 || _LAST_WAS_EMPTY=0
    zle accept-line
}
zle -N _tracked-accept-line
bindkey '^M' _tracked-accept-line
sudo-accept-line() {
    if [[ -n "${BUFFER//[[:space:]]/}" ]]; then BUFFER="sudo $BUFFER" _LAST_WAS_EMPTY=0
    else (( _LAST_WAS_EMPTY )) || BUFFER="sudo !!" _LAST_WAS_EMPTY=1
    fi
    zle accept-line
}
zle -N sudo-accept-line
bindkey $'\e[27;5;13~' sudo-accept-line
bindkey -M viins 'jk' vi-cmd-mode
export PATH="$HOME/.local/bin:$PATH"
HISTFILE=~/.zsh_history HISTSIZE=10000 SAVEHIST=10000 
