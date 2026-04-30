#!/bin/sh

if [ -f "$XDG_RUNTIME_DIR/hypr-scripts/numlock-on" ]; then
    NUMLOCK=1
else
    NUMLOCK=0
fi
if [ -f "$XDG_RUNTIME_DIR/hypr-scripts/capslock-on" ]; then
    CAPSLOCK=1
else
    CAPSLOCK=0
fi
if [ -f "$XDG_RUNTIME_DIR/hypr-scripts/touchpad-off" ]; then
    TOUCHPAD=0
else
    TOUCHPAD=1
fi

echo -n '{"text": "'
[ $NUMLOCK  -eq 1 ] && echo -n '󰎤'
[ $CAPSLOCK -eq 1 ] && echo -n '󰬈'
[ $TOUCHPAD -eq 0 ] && echo -n '󰍾'

echo -n '", "class": ['
is_first_indicator=1

# $1 - variable (e.g. $NUMLOCK)
# $2 - needed value (e.g. 1)
# $3 - class name (e.g. 'numlock')
make_class_for() {
    if [ $1 -eq $2 ]; then
        [ $is_first_indicator -eq 0 ] && echo -n ', '

        echo -n '"'$3'"'
        is_first_indicator=0
    fi
}

make_class_for $NUMLOCK  1 'numlock'
make_class_for $CAPSLOCK 1 'capslock'
make_class_for $TOUCHPAD 0 'touchpad'

echo -n '], "tooltip": "'

# $1 - variable (e.g. $NUMLOCK)
# $2 - make newline before text (e.g. 0)
# $3 - placeholder, it will automaticaly add ': ' (e.g. for 'Numlock' will be displayed 'Numlock: ')
# $4 - icon when on (e.g. '󰎤')
# $5 - icon when off (e.g. '󰎦')
make_tooltip_for() {
    [ $2 -eq 1 ] && echo -n '\n'
    [ $1 -eq 1 ] && echo -n "$4" || echo -n "$5"

    echo -n "  $3: <b>"

    [ $1 -eq 1 ] && echo -n 'on</b>' || echo -n 'off</b>'
}

make_tooltip_for $NUMLOCK  0 'Numlock'  '󰎤' '󰎦'
make_tooltip_for $CAPSLOCK 1 'Capslock' '󰬈' '󰯫'
make_tooltip_for $TOUCHPAD 1 'Touchpad'  '󰍽' '󰍾'

echo '"}'
