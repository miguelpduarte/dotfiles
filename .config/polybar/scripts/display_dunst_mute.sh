#!/usr/bin/env sh

state=$(dunstctl is-paused)

if $state; then
    echo ""
else
    echo ""
fi
