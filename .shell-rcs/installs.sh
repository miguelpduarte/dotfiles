#!/usr/bin/env bash

# Adding standalone executables to path
export PATH="/usr/local/sicstus4.4.1/bin/:$PATH"
export PATH="/home/miguel/Software/postman/Postman/:$PATH"

# https://asdf-vm.com
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# exporting the utils directory for some useful scripts
export PATH="/home/miguel/utils/:$PATH"

# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# fasd: https://github.com/clvv/fasd
# eval "$(fasd --init auto)" # Simple version. The below version caches fasd init code for minimal overhead on starting up the shell
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# Performance API (PAPI)
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# Getting python virtualenv manager aliases and functions
. "$HOME/.shell-rcs/python-venv-manager.sh"
