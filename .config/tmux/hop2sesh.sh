#!/usr/bin/env bash

# https://sipb.mit.edu/doc/safe-shell/
set -euf -o pipefail

sesh="$(tmux list-sessions -F\#S | fzf --tmux)";

if [ -n "$sesh" ]; then
	tmux switch-client -t "$sesh"
fi
