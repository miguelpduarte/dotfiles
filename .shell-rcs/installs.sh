#!/usr/bin/env bash

# Adding standalone executables to path
export PATH="/usr/local/sicstus4.4.1/bin/:$PATH"
export PATH="/home/miguel/Software/postman/Postman/:$PATH"
export PATH="/home/miguel/Software/clojure/joker/:$PATH"

# https://asdf-vm.com
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# exporting the utils directory for some useful scripts
export PATH="/home/miguel/utils/:$PATH"

# https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# fasd: https://github.com/clvv/fasd
eval "$(fasd --init auto)"

