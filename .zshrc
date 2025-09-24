#!/usr/bin/env zsh

#### zsh prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git 
zstyle ':vcs_info:git:*' formats 'on %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats 'on %F{yellow}%b%f%F{cyan}->%a%f'
precmd() {
    vcs_info
    # Ref from: https://codeberg.org/dnkl/foot/pulls/1088
    # Emits OSC-133 sequence before printing the prompt, so the terminal knows
    # where the prompts are. This enables jumping to them directly.
    print -Pn "\e]133;A\e\\"
    TW_CURR_CTX="$(task _get rc.context)"
}

# Prompt documentation
# %4~:directory up to 4, otherwise truncated; $vcs_stuff:git;tw ctx; shelllevel;
# conditionally printed exitcode; $/# prompt; <space>
PROMPT='
%B%4~%b ${vcs_info_msg_0_}%F{magenta}%B%(2L.{%L}.)%b%f %F{blue}${TW_CURR_CTX:+T($TW_CURR_CTX)}%f
%F{red}%B%(?..!%? )%b%f%B%(!.#.$)%b '

## To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals
# see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Just in case something wants me to edit something, to avoid loading into nano or vi...
export EDITOR=nvim
# As it should be <3

# Override default zsh options, see `man zshoptions`
unsetopt share_history
setopt inc_append_history
setopt hist_save_by_copy # weird: this should be enabled by default but isn't?
# setopt hist_no_store
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# HIST_EXPIRE_DUPS_FIRST recommends that HISTSIZE should be larger than SAVEHIST, but we don't have it set.
export SAVEHIST=6000
export HISTSIZE=6000

# https://unix.stackexchange.com/questions/6620/how-to-edit-command-line-in-full-screen-editor-in-zsh
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#ZLE-Functions
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

###### Install spam
# Add cargo installed packages to PATH
export PATH="$HOME/.cargo/bin:$PATH" # IF something breaks check here
###### END Install spam

###### Alias spam
### Git
alias g='git' # should've done this one a while ago
alias rui='git pull --ff-only'
alias rui-rb='git pull --rebase'
alias miguel='git push'
# oh-my-stolenzsh
alias gst='git status'
# You just lost the
alias game='git commit --amend'
alias gamer='game --reuse-message=HEAD'
## TODO: Move the below aliases to git config/delete them from here
# Git log short version
alias glog-s='git log --oneline --decorate'
alias glog-ga='git log --graph --all'
# For tracking merged or not merged branches. Aliases kinda unnecessary, but just good reminders to use these useful commands
# NOTE: Does not play well with GitHub's squash-and-merge, try to squash with interactive rebase first and then merge (without squashing!) using GitHub (or not!)
alias branches-merged='git branch --merged'
alias branches-not-merged='git branch --no-merged'

### Taskwarrior and friends
alias t='task'

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

### OS Specific
alias mac-cycle-wifi='networksetup -setairportpower en0 off; sleep 45; networksetup -setairportpower en0 on'

###### END Alias spam
