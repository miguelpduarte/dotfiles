#!/usr/bin/env sh

## For commands that need to happen before locking the screen
## Things such as pausing notifications, pausing autolocker, etc

# Pausing dunst notification daemon (don't show notifications on the lock screen)
# killall -SIGUSR1 dunst
dunstctl set-paused true

# Suspending xautolock - we don't want to try to lock multiple times...
# If it's not running (coffee mode) this exits with error but it's ok
xautolock -disable
