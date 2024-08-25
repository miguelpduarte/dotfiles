#!/usr/bin/env bash

### Git
alias rui='git pull --ff-only'
alias rui-rb='git pull --rebase'
alias miguel='git push'
# oh-my-stolenzsh
alias gst='git status'
# You just lost the
alias game='git commit --amend'
alias gamer='game --reuse-message=HEAD'
# Git log short version
alias glog-s='git log --oneline --decorate'
alias glog-ga='git log --graph --all'
# For tracking merged or not merged branches. Aliases kinda unnecessary, but just good reminders to use these useful commands
# NOTE: Does not play well with GitHub's squash-and-merge, try to squash with interactive rebase first and then merge (without squashing!) using GitHub (or not!)
alias branches-merged='git branch --merged'
alias branches-not-merged='git branch --no-merged'

### i3wm
# Usage: i3-move-workspace-to-output <left|down|up|right>
alias i3-move-workspace-to-output='i3-msg move workspace to output'
# Usage: i3-focus-output <left|down|up|right>
alias i3-focus-output='i3-msg focus output'

### Arch-stuff (btw I kinda use Arch)
# yay -Yc seems easier and more useful (?)
alias apt-autoremove='yay -Qdtq | yay -Rs -'

### task (warrior)
# Task ready to hide blocked or waiting stuff. Cannot use tr since that's a linux util
alias tt='task ready'
# Tasks done today https://www.reddit.com/r/taskwarrior/comments/n7nlpi/how_do_i_list_the_tasks_i_completed_today/
alias tdt='task end.after:yesterday completed'
# Tasks done yesterday, same idea as above
alias tdy='task end.after:yesterday-1d end.before:yesterday completed'
# Tasks done in the week, since the previous sunday (maybe change to start "counting" on monday?) (also maybe breaks on sunday, not sure)
alias tdw='task end.after:sun-1w completed'

### PDF and docs

# For merging pdfs
# pdfunite is also an option, but this is more efficient and results in smaller files overall

# Superb shrinks the size of pdfs by a lot but might not work as expected
# merge_pdf should be the default option and should work most often
# prepress is supposedly improved for low resolution pdfs
# (See https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf)
merge_pdf_superb() { gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages -dCompressFonts=true -r150 -sOutputFile=$@ ; }
merge_pdf() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ ; }
merge_pdf_prepress() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }


### Data parsing

# Using awk to get a specific column of a CSV (or similar) file
# Usage: get_csv_col <file> <colnr>
# Outputs to stdout by default, can be piped of course
get_csv_col() { awk -F, "{print \$$2}" "$1" ; }

# Using paste to join output by newlines
# So, for an input of lines of emails, this will result in a comma-separated list of emails
# Usage: join_lines_by <separator>
# Ex: cat emails.txt | join_lines_by ,
join_lines_by() { paste -sd "$1" ; }

# See https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
alias urlencode='python3 -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.quote_plus(l)) for l in sys.stdin]"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.unquote_plus(l)) for l in sys.stdin]"'

### Funny

weather() { curl "wttr.in${1:+/$1}" ; }

### Productivity/Speed-ups

# Creates a directory and instantly switches to it. Only works for one directory (as it only makes sense for one :upside_down:)
mkcd() { mkdir "$1"; cd "$1" || exit; }

# Opening a file directly in vim using fasd
alias v='f -e vim'
# Adding completion for above alias
_fasd_bash_hook_cmd_complete v

# Opens a new terminal window with the same env (as such will be in the same directory, same py venv, etc)
# alias split_term='(gnome-terminal &)'
alias split_term='(xfce4-terminal &)'
# Bind to <Alt-s>
bind -x '"\es": split_term;'

# Cleaning up docker (volumes, dangling images and containers, etc)
# Might need sudo if not in docker group
alias docker-cleanup='docker system prune -a --volumes'

### Other/Random utils

# Reloading my bash configs made easy
alias re_shrc='source ~/.bashrc'

# So I don't have to remember which clipboard cli tool I'm using now!
alias clipboard='xsel -b'

# I like to start weeks on sunday
alias cal='cal -s'

# Cli calculator!
alias calc='bc -lq'

# Opening files in sicstus (Sadly causes loss of shell prefix printing)
plog() { (echo "consult('$1')."; cat) | sicstus ; }

# Displays current spotify state if running
alias whats_playing='/home/miguel/.config/polybar/scripts/spotify_polybar.sh'
# Sometimes the wallpapers do not have the best color schemes for the terminal, sadly
alias sane-wal='wal --theme ashes'

# Add autocompletion to pwntools' checksec for files
complete -f checksec
