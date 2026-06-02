
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