#!/usr/bin/env bash

# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

# These are just sent to `fzf` directly without the `fd` search.
DIRECT_DIRS=(~/dotfiles)
dir="$( (fd . -t d ~/coding ~/my-coding --max-depth 1 ; printf '%s\n' "${DIRECT_DIRS[@]}") \
	| fzf --tmux)"

session_name="$(basename "$dir")"

wish_to_rename="$(echo -e "No (nN)\nYes (yY)" | fzf --tmux --header="Rename session? (current name: $session_name)")"
if [ "$wish_to_rename" = "Yes (yY)" ]; then
	# TODO: Instead of the shenanigans below, we can just run the script in a tmux popup directly.
	# I don't think there's even a use-case to running it outside of tmux, but in any case that would make it work :)
	# (check out that tmux popups video to confirm as well :)
	if [ -n "$TMUX" ]; then
		# TODO: Can't get input, need to pipe it somewhere, fzf seems to use a fifo:
		# https://github.com/junegunn/fzf/blob/master/src/proxy.go#L36
		# https://github.com/junegunn/fzf/blob/master/src/tmux.go#L60
		# TODO: Maybe some automated cleanup? this is become overkill at this point lol
		tmp_fifo="$(mktemp -u)"
		mkfifo -m 600 "$tmp_fifo"
		tmux popup -E -T "new session name:" "read -r -e '?name: ' > $tmp_fifo"
		# TODO: fix: somehow the above works but not this one.
		# tmux popup -E -T "new session name:" \
		# 	"read -r '?name: ' sname; echo \"\$sname\"; sleep 3"
		# Idea: I think that this is because of a "deadlock" on writing to the fifo?
		# maybe we can background the reader instead
		session_name="$(cat "$tmp_fifo")"
		unlink "$tmp_fifo"
	else
		read -r session_name
	fi
	# FIX: This doesn't work from inside tmux actually lol
	# TODO: Maybe get the input using a tmux prompt as well since fzf also can do it?
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
