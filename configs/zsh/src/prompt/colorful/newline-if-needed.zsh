
    local pos
    echo -n $'\e[6n' > /dev/tty
    read -s -d R pos < /dev/tty
    [[ "${pos#*\[}" != '1;'* ]] && echo