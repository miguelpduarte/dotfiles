#!/usr/bin/env sh

#overlay="$HOME/.config/i3/res/overlay.png"
tmpimg="/tmp/lockpic.png"

#take a screenshot and save that to "$tmpimg"
scrot "$tmpimg"

#add a gaussian blur and save that, overwriting the first picture
#convert "$tmpimg" -gaussian-blur 0x5 "$tmpimg"

#idea from https://www.reddit.com/r/unixporn/comments/69008j/i3gaps_1984/
#create a pixelized effect by scaling the image down and then up
convert "$tmpimg" -scale 10% -scale 1000% "$tmpimg"

#Apply an icon in the middle of the screen
#convert "$tmpimg" "$icon" -gravity center -composite -matte "$tmpimg"

# Add the overlay located by $overlay to the blurred screenshot and save that as "$tmpimg"
#composite "$overlay "$tmpimg" "$tmpimg"

# Pausing dunst notifications
killall -SIGUSR1 dunst

# Suspending xautolock - we don't want to try to lock multiple times...
pkill xautolock

# start i3lock with the overlayed + blurred picture at "$tmpimg"
# not forking in order to pause dunst notifications before locking and unpausing after locking (if forking, then both would run and everything would be the same)
# Idea from https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html
i3lock -i "$tmpimg" --nofork

# Unpausing dunst notifications
killall -SIGUSR2 dunst

# Resuming xautolock (does not deal with being in "coffee mode" after unlocking, but oh well, better to "over lock" than to "under lock")
(~/.config/i3/scripts/screen_timeout_lock.sh &)
