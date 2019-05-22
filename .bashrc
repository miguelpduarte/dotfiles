# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Init non default ubuntu bashrc stuff

#For powerline (powerline-status)
(powerline-daemon -q &)
if [ -f ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

# Add local 'pip' to PATH: (Needed for user-only installs)
#PATH="${PATH}:${HOME}/.local/bin/"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

#To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals:
#see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

#Exporting $TERMINAL variable
#Not sure if this is working, don't think so...
#If it is not, try sudo update-alternatives --config x-terminal-emulator
export TERMINAL=/usr/bin/gnome-terminal

##Adding NVM stuff
#Fixed performance, see https://github.com/creationix/nvm/issues/539#issuecomment-245791291
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Adding standalone executables to path
export PATH="/usr/local/sicstus4.4.1/bin/:$PATH"
export PATH="/home/miguel/Software/postman/Postman/:$PATH"
export PATH="/home/miguel/Software/clojure/joker/:$PATH"
export PATH="/home/miguel/Software/Go/go/bin/:$PATH"

# Exporting GOPATH
export GOPATH="/home/miguel/Coding/Go/"

# Custom commands
# Opening files in sicstus (Sadly causes loss of shell prefix printing)
plog() { (echo "consult('$1')."; cat) | sicstus; }

# For merging of pdfs
# pdfunite is also an option, but this is more efficient and results in smaller files overall

# Superb shrinks the size of pdfs by a lot but might not work as expected
# merge_pdf should be the default option and should work most often
# prepress is supposedly improved for low resolution pdfs
# (See https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf)
merge_pdf_superb() { gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages -dCompressFonts=true -r150 -sOutputFile=$@ ; }
merge_pdf() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ ; }
merge_pdf_prepress() { gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ; }

# Using awk to get a specific column of a CSV (or similar) file
# Usage: get_csv_col <file> <colnr>
# Outputs to stdout by default, can be piped of course
# Suspended for now due to nested variables not working i think
get_csv_col() { awk -F "\"*,\"*" "{print \$$2}" $1 ; }

# clipboard alias
alias clipboard='xsel -b'

alias rui='git pull --ff-only'
alias rui-rb='git pull --rebase'
alias miguel='git push'

# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# exporting the directory for some useful scripts
export PATH="/home/miguel/utils/:$PATH"
