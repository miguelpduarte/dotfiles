#!/usr/bin/env sh

selected_layout="$(find ~/.screenlayout/ -type f | rofi -dmenu -i -p "Monitor Setup")"

[ -n "$selected_layout" ] && $selected_layout
