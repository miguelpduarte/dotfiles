#!/usr/bin/env bash

# For powerline (powerline-status)
(powerline-daemon -q &)
if [ -f ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

# Import colorscheme from 'wal' asynchronously
(cat ~/.cache/wal/sequences &)

# To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals
# see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# Exporting $TERMINAL variable
# Not sure if this is working, don't think so...
# If it is not, try sudo update-alternatives --config x-terminal-emulator
export TERMINAL=/usr/bin/gnome-terminal

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Adding standalone executables to path
export PATH="/usr/local/sicstus4.4.1/bin/:$PATH"
export PATH="/home/miguel/Software/postman/Postman/:$PATH"
export PATH="/home/miguel/Software/clojure/joker/:$PATH"
export PATH="/home/miguel/Software/Go/go/bin/:$PATH"

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

# fasd: https://github.com/clvv/fasd
eval "$(fasd --init auto)"

# exporting the utils directory for some useful scripts
export PATH="/home/miguel/utils/:$PATH"

# https://asdf-vm.com
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# TODO: Switch to zshell (oh-my-zsh?) - too good features to miss but need to tweak some configs and the look too
