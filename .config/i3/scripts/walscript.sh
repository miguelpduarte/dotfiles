# First kill polybar
#killall -q polybar

walldir="$HOME/Pictures/Wallpapers/"

# Run the wal script using a random wallpaper
ls $walldir | sort -R | tail -$N | while read wallpaper; do
	wal -i $walldir/$wallpaper -t
	break;
done

# Rerun polybar
#($HOME/.config/polybar/launch.sh &) &> .err.log
