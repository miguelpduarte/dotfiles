#!/usr/bin/env sh

#If spotify is not running, output empty and leave
if ! pgrep -x spotify > /dev/null; then
	echo ""; exit
fi

STATUS=$(playerctl -p spotify status)
PAUSED_SEP=""
PLAYING_SEP=""

if [ "$STATUS" = "Paused" ]
then
	SEPARATOR=$PAUSED_SEP
elif [ "$STATUS" = "Playing" ]
then
	SEPARATOR=$PLAYING_SEP
else
	echo "Unknown player state";
fi

echo "$SEPARATOR $(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
