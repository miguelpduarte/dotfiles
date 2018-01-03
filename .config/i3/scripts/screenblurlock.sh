#! /bin/bash

#overlay="$HOME/.config/i3/res/overlay.png"
tmpimg="/tmp/lockpic.png"

#take a screenshot and save that to "$tmpimg"
scrot "$tmpimg"

#add a gaussian blur and save that, overwriting the first picture
#convert "$tmpimg" -gaussian-blur 0x5 "$tmpimg"

#idea from https://www.reddit.com/r/unixporn/comments/69008j/i3gaps_1984/
#create a pixelized effect by scaling the image down and then up
convert "$tmpimg" -scale 10% -scale 1000% "$tmpimg"

#Apply an icon in the middle of the screen
#convert "$tmpimg" "$icon" -gravity center -composite -matte "$tmpimg"

#add the overlay located at ~/.cheeselock/arch-logo-2.png to the blurred screenshot and save that as "$tmpimg"
#composite ~/.cheeselock/arch-logo-2.png "$tmpimg" "$tmpimg"

#start i3lock with the overlayed + blurred picture at "$tmpimg"
i3lock -i "$tmpimg"
