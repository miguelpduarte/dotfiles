#!/usr/bin/env sh

less "$1" | tail -n +"${2:-2}" | awk '{print $NF}' | sort
