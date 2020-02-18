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
alias apt-autoremove='yay -Qdtq | yay -Rs -'

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
get_csv_col() { awk -F, "{print \$$2}" $1 ; }

# Using paste to join output by newlines
# So, for an input of lines of emails, this will result in a comma-separated list of emails
# Usage: join_lines_by <separator>
# Ex: cat emails.txt | join_lines_by ,
join_lines_by() { paste -sd $1 ; }

### Funny

weather() { curl "wttr.in${1:+/$1}" ; }

# Productivity/Speed-ups

# Creates a directory and instantly switches to it. Only works for one directory (as it only makes sense for one :upside_down:)
mkcd() { mkdir $1; cd $1; }

# Opening a file directly in vim using fasd
alias v='f -e vim'
# Adding completion for above alias
_fasd_bash_hook_cmd_complete v

### Other/Random utils

# So I don't have to remember which clipboard cli tool I'm using now!
alias clipboard='xsel -b'

# Cli calculator!
alias calc='bc -lq'

# Opening files in sicstus (Sadly causes loss of shell prefix printing)
plog() { (echo "consult('$1')."; cat) | sicstus ; }


# "format": "{state_symbol} {artist} - {title} ({total})",
# "play": "",
# "pause": "",
# "stop": "",
# "fallback": ""

# Displays current spotify state if running
alias whats_playing='/home/miguel/.config/polybar/scripts/spotify_polybar.sh'
