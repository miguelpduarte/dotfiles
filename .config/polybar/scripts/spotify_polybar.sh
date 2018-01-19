#!/usr/bin/env sh

STATUS="$(playerctl status)"

echo "Here goes";
echo "$STATUS";

if [ "$STATUS" == "Paused" ]
then
	echo "Pzd";
elif [ "$STATUS" == "Playing" ]
then
	echo "Pl";
	echo "$(playerctl metadata artist) - $(playerctl metadata title)"
else
	echo "Idk";
fi
