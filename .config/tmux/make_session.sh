#!/usr/bin/env bash

# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

dir="$(fd . -t d ~/coding ~/my-coding --max-depth 1 | fzf --tmux)"

session_name="$(basename "$dir")"

wish_to_rename="$(echo -e "No (nN)\nYes (yY)" | fzf --tmux --header="Rename session? (current name: $session_name)")"
if [ "$wish_to_rename" = "Yes (yY)" ]; then
	read -r session_name
	# TODO: Maybe get the input using a tmux prompt as well since fzf also can do it?
fi

# TODO: Add switch to maybe just create a simple session without these windows.
# But I can always just close out of them too, so just sticking to this for now

tmux new-session -d -c "$dir" -s "$session_name" -n 'edit'
tmux neww -t "$session_name" -n 'cmd'
tmux neww -t "$session_name" -n 'git'
tmux attach -t "$session_name"
