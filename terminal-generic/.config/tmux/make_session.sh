#!/usr/bin/env bash

# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

# These are just sent to `fzf` directly without the `fd` search.
DIRECT_DIRS=(~/dotfiles ~/nixos-configs)
# TODO: Suppress `fd` stderr for not finding the dirs we pass into it.
dir="$( (fd . -t d ~/coding ~/my-coding --max-depth 1 ; printf '%s\n' "${DIRECT_DIRS[@]}") \
	| fzf)"

# Check if dir exists, just to be able to abort the script if not
# (only possible because of the hardcoded "direct dirs" above 😅)
if ! [ -d "$dir" ]; then
	echo "ERROR: Chosen dir does not exist: $dir"
	sleep 2
	exit 1
fi

session_name="$(basename "$dir")"

wish_to_rename="$(echo -e "No (nN)\nYes (yY)" | fzf --header="Rename session? (current name: $session_name)")"
if [ "$wish_to_rename" = "Yes (yY)" ]; then
	read -r -p "New session name (current name: $session_name): " session_name
fi

# TODO: Add switch to maybe just create a simple session without these windows.
# But I can always just close out of them too, so just sticking to this for now

tmux new-session -c "$dir" -s "$session_name" -n 'edit' -d
tmux neww -t "$session_name" -c "$dir" -n 'cmd'
tmux neww -t "$session_name" -c "$dir" -n 'git'

# Detect if we are in tmux. If yes, then switch, otherwise attach
if [ -n "$TMUX" ]; then
	tmux switch-client -t "$session_name"
else
	tmux attach -t "$session_name"
fi
