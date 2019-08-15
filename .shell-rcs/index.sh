#!/usr/bin/env bash

# To fix vim and less, etc to not freeze with ctrl-s ctrl-q in terminals
# see: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

#To make sure there are no apps trying to reinstall old versions of node
alias nodejs='node'

# Sourcing other config files

. "$HOME/.shell-rcs/installs.sh"
. "$HOME/.shell-rcs/aliases.sh"
