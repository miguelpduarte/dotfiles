#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Update: See https://github.com/polybar/polybar/pull/1426
# # See https://github.com/polybar/polybar/wiki#dealing-with-xrandr-15-randomized-monitor-names
# # export MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')
# export MONITOR=$(polybar -m|grep primary|sed -e 's/:.*$//g')

# Launch example bar for the time being
polybar main &


echo "Bars launched..."

#For future testing
#source "${HOME}/.cache/wal/colors.sh"
#background=$color0
#background_alt=$color3
#foreground=$color15
#foreground_alt=$color2
#highlight=$color4
