#!/usr/bin/env bash

# Getting the branch of the current directory
function get_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Setting prompt old-school-style
# Non-printing escape sequences (namely colors) should be enclosed in '\[\033[' and '\]'
# Escape sequences themselves usually start with a '['
# Furthermore, color escape sequences should end with 'm'
function my_prompt() {
    local BOLD_GREEN='\[\033[01;31m\]'
    local BOLD_RED='\[\033[01;32m\]'
    local BOLD_BLUE='\[\033[01;34m\]'
    local BOLD_PURPLE='\[\033[01;35m\]'
    local NO_COLOR='\[\033[00m\]'

    # Show only the last 3 directory names (requires Bash 4)
    PROMPT_DIRTRIM=3

# Indentation due to space mattering for prompt output
# TODO make this not as bad (newline before each prompt) - investigate sneaky trap option
# The second line is getting the current git branch if in a repository and pretty (- hopefully!) printing it
MY_PS1="\n\
$BOLD_GREEN\w$NO_COLOR\
\$(branch=\"\$(get_git_branch)\";echo \${branch:+\" on ${BOLD_PURPLE}\$branch$NO_COLOR\"})\n\
\${debian_chroot:+(\$debian_chroot)}$BOLD_RED\u@\h$NO_COLOR\\$ "
}

# Applying my prompt
my_prompt

# Keeping defaults for safety
DEFAULT_COLOR_PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

## Stolen stuff from ubuntu .bashrc (interjected MY_PS1)
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
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
## End stolen stuff

