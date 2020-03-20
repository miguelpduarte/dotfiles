#!/usr/bin/env sh

# Directory where the wallpapers are stored
WALLDIR="$HOME/Pictures/Wallpapers/alltogethernow"

# Polybar reload no longer necessary as pywal does it
# killall -q polybar

# Now this is enough since my pywal is no longer broken (not thanks to ubuntu lmao)
wal -i "$WALLDIR" --vte

# Rerun polybar # No longer necessary
# ($HOME/.config/polybar/launch.sh &) &> .err.log
