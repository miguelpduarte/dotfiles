# dotfiles
The dotfiles I am currently using in Linux

## Currently using:
- [i3wm](https://i3wm.org/)
- i3blocks (now moved to Polybar but config is still there - now commented out or deleted in i3 config file but the i3blocks config file itself is still here)
- [pywal](https://github.com/dylanaraps/pywal)
- [i3lock](https://github.com/i3/i3lock) (thinking of trying i3lock-color for further customization)
- vim
- gnome-terminal (works for me and I see no need to switch - Used terminator before but i3 gives me tiling anyway so it's ok like this)
- [powerline](https://github.com/powerline/powerline) (for status line in shell and in vim) - need to find an alternative since the time it takes on shell startup is veeeeery long
- [Polybar](https://github.com/jaagr/polybar)
- [yadm](https://thelocehiliosan.github.io/yadm/) for dotfile management (simple and uses git directly so no overhead to learn new commands, highly recommend it!)
- [fusuma](https://github.com/iberianpig/fusuma) for mapping commands to touchpad gestures - very simple to use and configure, recommend it a lot!

## Plan to use/customize:
- [Dunst](https://github.com/dunst-project/dunst)

## Requirements:
- `Pavucontrol` (for audio display with i3blocks)
- `playerctl` (for audio keys control and listing current song in polybar)
- `scrot` for screenshots in the blur lock screen
- `imagemagick` for blurring the screenshot
- `light` for managing screen backlight (xbacklight stopped working for me)

### Some notes:
- If you are using Ubuntu or any \*buntu versions, you might need to install some software "manually" (compile from source) because the repositories might be a bit out of date (IIRC, did that with rofi and pywal at least).
