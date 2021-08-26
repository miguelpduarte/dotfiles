#!/usr/bin/env bash

# Inspired by https://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before-2/

# I don't think this does anything.. This file does not appear to exist neither here nor anywhere on my system.
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Found the completion file, sourcing it:
source /usr/share/fzf/completion.bash
# Not sure about sourcing the keybinds since I may find them too intrusive for me
# This has: <C-r> (fzf in history), directory expansion with dir/**<tab>, <A-c> to change directory, and <C-t> to insert selected file into a command.
# <C-p> also added below
source /usr/share/fzf/key-bindings.bash
# An alias in case I disable them by default and want to try them out
alias enable-fzf-keybinds='source /usr/share/fzf/key-bindings.bash'


# Changed up the one in the blogpost to respect gitignore files (since sometimes the directories to ignore are not node_modules nor .git - e.g. other languages such as elixir that use other dirs such as "deps")
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# Ugly singlequote escaping but it seems better than accidentally doing something with events in bash (! symbol)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g '\''!.git/'\'' 2>/dev/null'

# I'm not sure about the idea of overriding ctrl-p even if it is simply in bash. Maybe I'll grow into it
# shellcheck disable=SC2016
bind -x '"\C-p": vim $(fzf);'
# Also as an alias in case I forget or prefer to use it as a cli tool
alias browsedit='vim $(fzf)'

# Trying out 'bfs' (https://github.com/tavianator/bfs) since it is find but breadth-first (which makes more sense for cd). Annoying since it's AUR and not other repo but I'll live
# # Also trying out the concept of switching based on the home. I was finding <A-c> interesting for going deeper into a directory but this may be an interesting alternative to fasd's `z`
# Maybe not, especially since it isn't working lol
# export FZF_ALT_C_COMMAND="cd ~/; bfs -type d -nohidden | sed s/^\./~/"
export FZF_ALT_C_COMMAND="bfs -type d -nohidden"
