#!/usr/bin/env zsh

#### zsh prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:git:*' formats 'on %F{yellow}%b%f %a'
precmd() {
    vcs_info
}

PROMPT='
%B%4~%b ${vcs_info_msg_0_}
%F{red}%B%(?..!%? )%b%f%B%(!.#.$)%b '

## To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals
# see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Just in case something wants me to edit something, to avoid loading into nano or vi...
export EDITOR=nvim
# As it should be <3

setopt no_share_history
unsetopt share_history

###### Install spam
# Add cargo installed packages to PATH
export PATH="$HOME/.cargo/bin:$PATH"
###### END Install spam

###### Alias spam
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

# Cleaning up docker (volumes, dangling images and containers, etc)
# Might need sudo if not in docker group
alias docker-cleanup='docker system prune -a --volumes'

### Other/Random utils

# Reloading my bash configs made easy
alias re_zshrc='source ~/.zshrc'

# I like to start weeks on sunday
alias cal='cal -s'

# Cli calculator!
alias calc='bc -lq'

alias ls='ls -F --color'
alias ll='ls -la'
###### END Alias spam
