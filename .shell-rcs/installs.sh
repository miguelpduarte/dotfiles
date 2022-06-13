#!/usr/bin/env bash

## https://asdf-vm.com
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# yadm completions
source /usr/share/bash-completion/completions/yadm

# exporting the utils directory for some useful scripts
export PATH="/home/miguel/utils/:$PATH"

# Add cargo installed packages to PATH
export PATH="~/.cargo/bin:$PATH"

# https://github.com/nvbn/thefuck
eval "$(thefuck --alias)"

# fasd: https://github.com/clvv/fasd
# eval "$(fasd --init auto)" # Simple version. The below version caches fasd init code for minimal overhead on starting up the shell
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

## My stuff (custom made / configurations)
# Getting python virtualenv manager aliases and functions
. "$HOME/.shell-rcs/python-venv-manager.sh"
# Sourcing fzf and ripgrep setup (check https://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before-2/)
. "$HOME/.shell-rcs/fzf-rg-combomeal.sh"
