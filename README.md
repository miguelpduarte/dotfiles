# dotfiles
The dotfiles I am currently using in Linux

## Currently using:
- [`i3wm`](https://i3wm.org/)
- [`pywal`](https://github.com/dylanaraps/pywal)
- [`i3lock`](https://github.com/i3/i3lock) (thinking of trying i3lock-color for further customization)
- `vim` - :)
- [`rofi`](https://github.com/davatorium/rofi) (because default dmenu launcher is not very cool :P)
- `gnome-terminal` (works for me and I see no need to switch - Used terminator before but i3 gives me tiling anyway so it's ok like this)
- [`polybar`](https://github.com/jaagr/polybar) (awesome bar!)
- [`yadm`](https://thelocehiliosan.github.io/yadm/) for dotfile management (simple and uses git directly so no overhead to learn new commands, highly recommend it!)
- [`fusuma`](https://github.com/iberianpig/fusuma) for mapping commands to touchpad gestures - very simple to use and configure, recommend it a lot!
- [`Dunst`](https://github.com/dunst-project/dunst)

## Plan to use/customize/do:
- Cool custom screenshotting shortcuts
- Volume change keybind modifier key to change 1% at a time
- Notification muting in taskbar (similar to the current coffee mug/bed for locking)
- `xrandr` keybind shortcuts (I keep using `arandr` like a n00b)

## 'Random' Requirements:
- `pavucontrol` (for audio display with i3blocks) (I think this was dropped in the switch to polybar but not yet sure)
- [`playerctl`](https://github.com/acrisci/playerctl) for audio keys control and listing current song in polybar - If using ubuntu needs to be built from source (or installed from the provided built package) as the version in `apt` is very outdated (new commands are cool too)
- `scrot` for screenshots in the blur lock screen
- `imagemagick` for blurring the screenshot
- `light` for managing screen backlight (xbacklight stopped working for me)

## No longer used/dropped:
- i3blocks (config is still here but now moved to Polybar - commented out or deleted references in i3 config file though)
- [powerline](https://github.com/powerline/powerline) (bash and vim status line): Felt too slow and configuration mechanism was clunky. Once it failed on me randomly (after an update, probably) I just moved to plain bash `PS1`.


### Some notes:
- If you are using Ubuntu or any \*buntu versions, you might need to install some software "manually" (compile from source) because the repositories might be a bit out of date (IIRC, did that with rofi and pywal at least).
