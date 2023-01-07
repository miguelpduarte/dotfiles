#!/usr/bin/env sh

selected_layout="$(find ~/.screenlayout/ -type f | rofi -dmenu -i -p "Monitor Setup")"

# Relaunching polybar if the switch was successful since that's the fix I usually do by hand anyway
[ -n "$selected_layout" ] && $selected_layout && ~/.config/polybar/launch.sh
