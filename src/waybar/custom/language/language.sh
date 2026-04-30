#!/bin/sh
KEYMAP=$(hyprctl -j devices | jq -r '.keyboards[] | select(.name == "asus-wireless-radio-control") | .active_keymap')
case "$KEYMAP"
  "English (US)") echo '{"text": "EN 🇺🇸"}';;
  "Russian")      echo '{"text": "RU 🇷🇺"}';;
  *)              echo "{\"text\": \"$KEYMAP 󰌌\"}";; 
esac
