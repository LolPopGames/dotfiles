PROMPT='#~~newline~~##~~system~~# #~~user~~# %F{blue}[#~~dir_icon~~#] %~#~~git~~#
%(?.%F{green}.%F{red})%(#.=>.->)%f ' RPROMPT='%(?%F{green}.%F{red})%?#~~exitcode_char~~# #~~exec_time~~#%(1j.%F{cyan}%(2j.%j.)[#~~job_char~~#] .)%f%*' PROMPT2='%F{11}%_ %F{yellow}%(#.<==.<--)%f ' PROMPT3='%F{12}%(#.=>.->)?%f ' PROMPT4='%F{#~~debug_color~~#}[#~~debug_char~~#] %F{#~~debug_context_color~~#}%N %F{#~~debug_line_color~~#}(%i)%f ' SPROMPT=$'zsh: Did you mean %F{10}%r%f? %F{12}[ynae]%f: '
#~~preexec~~#
#~~precmd~~#
