#!/usr/bin/env sh

#If xautolock is not running, then display coffee icon
if ! pgrep -x xautolock > /dev/null; then
	echo ""
else
#If xautolock is running then display bed icon
	echo ""
fi

