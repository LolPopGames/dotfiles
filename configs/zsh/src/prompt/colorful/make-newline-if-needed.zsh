    local position
    echo -ne $'\e[6n' > /dev/tty
    read -s -d R position < /dev/tty
    [[ "${position#*\[}" != '1;'* ]] && echo
