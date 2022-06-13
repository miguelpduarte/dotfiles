#!/usr/bin/env sh

# Sourcing pywal variables to get the current wallpaper
# shellcheck source=/dev/null
. "$HOME/.cache/wal/colors.sh"

tmpimg="/tmp/wallpaper_lock"
default_wall="/home/miguel/Pictures/Wallpapers/wallhaven-28ekym_1920x1080-fs8.png"
# icon="$HOME/.config/i3/images/lock-icon_white_small.png"
# overlay="$HOME/.config/i3/imgs/overlay.png"

# Ensure image fills screen
# (Should probably do this to every image before even using them as wallpaper, this feels hacky - however, it's easier to do at the moment, I will do that in the future...)

resolution="$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')"
width="${resolution%x*}"
height="${resolution#*x}"

# Handle when there is no wallpaper set ($wallpaper = None)
if [ "$wallpaper" = "None" ]; then
    wallpaper="$default_wall"
fi

### TODO: Speed up the following section, especially for images that already have the correct resolution (only the black circle should be added)
# echo 3
# I should vary between $background and $color1 depending on the image. Going to use background for now and if there is an image that should use color1 I can just pre-process it and then this will no longer have any effect :)
## The second line also adds a translucid black circle to the center for the time and date
convert "$wallpaper" -sample "$resolution" -background "$background" -gravity center -extent "$resolution" \
    -gravity center -fill '#000000cf' -draw "translate $((width/2)),$((height/2)) circle 0,0 125,0" \
    "$tmpimg"

# echo 4

# Apply an icon in the middle of the screen
# convert "$tmpimg" "$icon" -gravity center -composite -matte "$tmpimg"

# Add the overlay located by $overlay to the blurred screenshot and save that as "$tmpimg"
# composite "$overlay" "$tmpimg" "$tmpimg"

## Run pre-lock hooks
"$HOME/.config/i3/scripts/pre_lock.sh"

# start i3lock with the overlayed + wallpaper picture at "$tmpimg"
# not forking in order to pause dunst notifications before locking and unpausing after locking
# Idea from https://faq.i3wm.org/question/5654/how-can-i-disable-notifications-when-the-screen-locks-and-enable-them-again-when-unlocking/index.html
i3lock -eCi "$tmpimg" \
    --inside-color='ffffff00' --ring-color='ffffffff' --line-uses-inside \
    --insidever-color='0000ff00' --insidewrong-color='ff000000' \
    --keyhl-color="${color1/#/}ff" \
    --radius=125 --verif-text='' --wrong-text='' \
    --clock --date-str='%A, %d/%m/%y' --time-color='ffffffff' --date-color='ffffffff' \
    --nofork

    #--indpos="x+w/10:y+h-h/10" \
    #--timepos="x+w/2:y+h/2" --datepos="tx:ty+20" \

## Run post-lock hooks
"$HOME/.config/i3/scripts/post_lock.sh"
