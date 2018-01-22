#!/usr/bin/env sh


#The -corners option specifies that putting the mouse in the top left corner disables the lock (useful for watching movies) and putting it in the top right corner fires the lock

xautolock -time 9 -corners -+00 -notify 5 -notifier "notify-send 'Locking the screen...'" -locker "~/.config/i3/scripts/screenblurlock.sh"
