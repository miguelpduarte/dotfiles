#!/usr/bin/env sh


#The -corners option specifies that putting the mouse in the top left corner disables the lock (useful for watching movies) and putting it in the top right corner fires the lock

LOCK_SCRIPT="~/.config/i3/scripts/screen_lock_blur.sh"

xautolock -time 9 -corners -+00 -notify 5 -notifier "notify-send 'Locking the screen...'" -locker "$LOCK_SCRIPT"
