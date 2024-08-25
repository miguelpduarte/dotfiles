#!/usr/bin/env bash

# To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals
# see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Just in case something wants me to edit something, to avoid loading into nano or vi...
export EDITOR=nvim
# As it should be <3

# Sourcing other config files

. "$HOME/.shell-rcs/installs.sh"
. "$HOME/.shell-rcs/prettify.sh"
. "$HOME/.shell-rcs/aliases.sh"
