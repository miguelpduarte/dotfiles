#!/usr/bin/env sh

## For commands that need to happen after unlocking the screen
## Things such as resuming notifications, resuming autolocker, etc

# Resuming dunst notification daemon (not being used atm)
# killall -SIGUSR2 dunst

# Resuming xautolock (like in pre_lock.sh, if not running exits with error but it's ok)
xautolock -enable
