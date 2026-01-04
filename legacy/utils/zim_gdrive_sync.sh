#!/usr/bin/env bash

args=()
[ -n "$1" ] && args+=( '--dry-run' )

rclone sync "$HOME/Zim Notebooks" gdrive:'Zim Notebooks' \
    --create-empty-src-dirs --progress \
    "${args[@]}"

exit_val="$?"

notify-send "Ran Zim Notebooks backup with exit code: $exit_val"

if [ "$exit_val" -eq 0 ]; then
    echo 'ZIM_GDRIVE: Zim backups successful' | /usr/bin/logger -i
else
    echo 'ZIM_GDRIVE: Zim backups errored!' | /usr/bin/logger -i
fi
