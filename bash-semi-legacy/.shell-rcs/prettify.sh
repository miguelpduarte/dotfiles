#!/usr/bin/env bash

# # For powerline (powerline-status)
# (powerline-daemon -q &)
# if [ -f ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
#     source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
# fi

# Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)

# Custom bash prompt
source "$HOME/.shell-rcs/bash-prompt.sh"

