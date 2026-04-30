#!/bin/sh

# API: ./toggles-api.sh toggle-name default-state cmd-if-enabled cmd-if-disabled

mkdir -p "$XDG_RUNTIME_DIR/hypr-scripts"

if [ "$2" = "on" ]; then
    if [ -f "$XDG_RUNTIME_DIR/hypr-scripts/$1-off" ]; then
        sh -c "$3"

        rm "$XDG_RUNTIME_DIR/hypr-scripts/$1-off"
    else
        sh -c "$4"

        touch "$XDG_RUNTIME_DIR/hypr-scripts/$1-off"
    fi
else
    if [ -f "$XDG_RUNTIME_DIR/hypr-scripts/$1-on" ]; then
        sh -c "$4"

        rm "$XDG_RUNTIME_DIR/hypr-scripts/$1-on"
    else
        sh -c "$3"

        touch "$XDG_RUNTIME_DIR/hypr-scripts/$1-on"
    fi
fi
