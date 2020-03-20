#!/usr/bin/env sh

# Sourcing pywal variables to get the current wallpaper
# shellcheck source=/dev/null
. "$HOME/.cache/wal/colors.sh"

tmpimg="/tmp/wallpaper_lock"
# icon="$HOME/.config/i3/imgs/icon.png"
# overlay="$HOME/.config/i3/imgs/overlay.png"

# Ensure image fills screen
# (Should probably do this to every image before even using them as wallpaper, this feels hacky - however, it's easier to do at the moment, I will do that in the future...)

resolution="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"

echo "$resolution"

convert "$wallpaper" -resize "$resolution" -background "$background" -compose Copy \
    -gravity center -extent "$resolution" \
    "$tmpimg"

# Apply an icon in the middle of the screen
# convert "$tmpimg" "$icon" -gravity center -composite -matte "$tmpimg"

# Add the overlay located by $overlay to the blurred screenshot and save that as "$tmpimg"
# composite "$overlay" "$tmpimg" "$tmpimg"

"$HOME/.config/i3/scripts/pre_lock.sh"

# start i3lock with the overlayed + blurred picture at "$tmpimg"
# not forking in order to pause dunst notifications before locking and unpausing after locking (if forking, then both would run and everything would be the same)
# Idea from https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html
i3lock -i "$tmpimg" --nofork

"$HOME/.config/i3/scripts/post_lock.sh"
