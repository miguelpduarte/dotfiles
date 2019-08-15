#!/usr/bin/env bash

# Getting the branch of the current directory
function get_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Setting prompt old-school-style (using PS1)

# Notes for printing stuff:
# Non-printing escape sequences (namely colors) should be enclosed in '\[\033[' and '\]'
# Escape sequences themselves usually start with a '['
# Furthermore, color escape sequences should end with 'm'

function __my_prompt_command() {
    # Needs to be first
    local last_exit_status="$?"
    PS1=''
    
    local bold_red='\[\033[01;31m\]'
    local bold_green='\[\033[01;32m\]'
    local bold_blue='\[\033[01;34m\]'
    local bold_purple='\[\033[01;35m\]'
    local no_color='\[\033[00m\]'
    
    # TODO make this (spacing between commands) not as bad (newline before each prompt) - investigate sneaky trap option
    PS1+="\n"
    
    # Working directory
    PS1+="$bold_green\w$no_color"

    # Displaying the current branch if in a git repository
    local branch="$(get_git_branch)"
    if [[ -n "$branch" ]]; then
	PS1+=" on $bold_purple$branch$no_color"
    fi
    
    if [ "$last_exit_status" != 0 ]; then
	PS1+=" $bold_green!$last_exit_status"
    fi

    PS1+="\n${debian_chroot:+($debian_chroot)}$bold_red\u@\h$no_color\$ "
}

# Applying my prompt
PROMPT_COMMAND=__my_prompt_command

# Show only the last 3 directory names (requires Bash 4)
PROMPT_DIRTRIM=3

# Keeping defaults for safety
DEFAULT_COLOR_PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

## Stolen stuff from ubuntu .bashrc (some slight changes)
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
    PS1="${MY_PS1:-$DEFAULT_COLOR_PS1}"
else
    # Ensuring  that when color is not supported no changes to PS1 are done
    # Should probably provide colorless version, but too lazy atm and do not enter colorless shells too often :^)
    unset __my_prompt_command
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
## End stolen stuff

