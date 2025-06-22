#!/usr/bin/env bash

# https://sipb.mit.edu/doc/safe-shell/
set -uf -o pipefail
# no -e because fzf exit code doesn't matter, we just want to check the output

sesh="$(tmux list-sessions -F\#S | fzf --tmux)";

if [ -n "$sesh" ]; then
	tmux switch-client -t "$sesh"
fi
