#!/usr/bin/env sh

## For commands that need to happen after unlocking the screen
## Things such as resuming notifications, resuming autolocker, etc

# Resuming dunst notification daemon
## Sadly this does not handle the case in which I had the notifications paused before locking and wish that they would remain paused, but I don't see an easy way to handle this atm, so I'll just rely on myself to pause them again
# killall -SIGUSR2 dunst
dunstctl set-paused false

# Resuming xautolock (like in pre_lock.sh, if not running exits with error but it's ok)
xautolock -enable
