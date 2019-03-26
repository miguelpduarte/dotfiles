#!/usr/bin/env sh

#overlay="$HOME/.config/i3/imgs/overlay.png"
# tmpimg="/tmp/lockpic.png" # Copied from the other script

# Sourcing pywal variables to get the current wallpaper
. $HOME/.cache/wal/colors.sh

tmpimg="$wallpaper"
# tmpimg="changeme" # (Arranjar um wallpaper simples fixe, png)

#Apply an icon in the middle of the screen
#convert "$tmpimg" "$icon" -gravity center -composite -matte "$tmpimg"

# Add the overlay located by $overlay to the blurred screenshot and save that as "$tmpimg"
#composite "$overlay "$tmpimg" "$tmpimg"

# Pausing dunst notifications
killall -SIGUSR1 dunst

# Suspending xautolock - we don't want to try to lock multiple times...
# If it's not running (coffee mode) this exits with error but it's ok
xautolock -disable

# start i3lock with the overlayed + blurred picture at "$tmpimg"
# not forking in order to pause dunst notifications before locking and unpausing after locking (if forking, then both would run and everything would be the same)
# Idea from https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html
i3lock -i "$tmpimg" --nofork

# Unpausing dunst notifications
killall -SIGUSR2 dunst

# Resuming xautolock (like above, if not running exits with error but it's ok)
xautolock -enable
