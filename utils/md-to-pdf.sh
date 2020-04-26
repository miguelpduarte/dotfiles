#!/usr/bin/env bash

filename="${1%.*}"
config_file="$HOME/utils/pandoc_configs/default_config"

# pandoc -s $1 --latex-engine=xelatex --listings -H listings-setup.tex -o $filename.pdf
pandoc -s <(cat "$config_file" "$1") -o "$filename".pdf --pdf-engine=xelatex
