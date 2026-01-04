#!/usr/bin/env sh

#If xautolock is not running, then start the autolocker and exit
if ! pgrep -x xautolock > /dev/null; then
	# &   # Run the process in the background.
	# ( ) # Hide shell job control messages.
	(~/.config/i3/scripts/screen_timeout_lock.sh &)
else
#If xautolock is running then kill the process to stop it
	pkill xautolock	
fi

