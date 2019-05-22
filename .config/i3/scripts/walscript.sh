#!/usr/bin/env sh

# Polybar reload no longer necessary as pywal does it
#killall -q polybar

walldir="$HOME/Pictures/Wallpapers/alltogethernow"

# Run the wal script using a random wallpaper
#Lists the sources in the wallpaper directory then picks a random one
#If it can read the wallpaper then it passes the wallpaper to wal so it does its job (just to prevent from passing in a bad path to wal)
ls $walldir | sort -R | tail -$N | while read wallpaper; do
	wal -i "$walldir/$wallpaper" --vte;
	export WALLIMG="$walldir/$wallpaper";
	echo "meme $WALLIMG";
	break;
done

# Rerun polybar # No longer necessary
# ($HOME/.config/polybar/launch.sh &) &> .err.log
