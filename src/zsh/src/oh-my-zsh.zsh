[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
alias build-zshrc='$ZSHRC_BUILDER' configure-zshrc='vim $ZSHRC_CONFIG'
ZSH_THEME='powerlevel10k/powerlevel10k' plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting vi-mode z)
export ZSH="$HOME/.oh-my-zsh" VI_MODE_CURSOR_NORMAL=2 VI_MODE_CURSOR_VISUAL=6 VI_MODE_CURSOR_INSERT=6 VI_MODE_CURSOR_APPEND=0 ZSH_CUSTOM="$HOME/.config/zsh"
export ZSHRC_BUILDER="$ZSH_CUSTOM/build.zsh" ZSHRC_CONFIG="$ZSH_CUSTOM/build-config.zsh"
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
