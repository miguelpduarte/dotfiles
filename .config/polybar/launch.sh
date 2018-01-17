#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

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
