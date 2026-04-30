local make_newline_if_needed__position
echo -ne $'\e[6n' > /dev/tty
read -s -d R make_newline_if_needed__position < /dev/tty
[[ "${make_newline_if_needed__position#*\[}" != '1;'* ]] && echo

