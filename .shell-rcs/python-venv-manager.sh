#!/usr/bin/env bash

## Python virtual environment manager, using virtualenv internally (via the python>3.3 module 'venv')

export VIRTUAL_ENV_DIR="$HOME/python_envs"

venv_create() {
    local name="${1:?No name for the environment given.}"
    shift

    python -m venv "$VIRTUAL_ENV_DIR/$name" "$@"
    return "$?"
}

venv_activate() {
    local name="${1:?No virtual environment given.}"
    shift

    # shellcheck source=/dev/null
    source "$VIRTUAL_ENV_DIR/$name/bin/activate"
    return "$?"
}

# Just so I don't forget it
alias venv_leave='deactivate'

venv_destroy() {
    local name="${1:?No virtual environment given.}"
    shift

    if [[ -n "$VIRTUAL_ENV" ]]; then
	# If the virtual env is active, leave it so that things don't break
	# TODO: Maybe check if the activated virtual env is the same as we are destroying before leaving it :D
	deactivate
    fi

    rm -rf "${VIRTUAL_ENV_DIR:?}/$name"
}

_venv_names() {
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
	return
    fi

    local IFS=$'\n'
    mapfile -t suggestions < <(compgen -W "$(ls "$VIRTUAL_ENV_DIR")" -- "${COMP_WORDS[1]}")

    for i in "${!suggestions[@]}"; do
	if [[ "${suggestions[i]}" = *" "* ]]; then
	    suggestions[$i]="'${suggestions[i]}'"
	fi
    done

    COMPREPLY=("${suggestions[@]}")

#    if [ "${#suggestions[@]}" == "1" ] && [[ "${suggestions[0]}" = *" "* ]]; then
#	# If the suggestion is only 1 and it has spaces, then add '' around it
#	COMPREPLY=("'${suggestions[0]}'")
#    else
#    fi

    # COMPREPLY=($(compgen -W "$(ls "$VIRTUAL_ENV_DIR")" -- "${COMP_WORDS[1]}"))

}

complete -F _venv_names venv_activate
complete -F _venv_names venv_destroy

venv_list() {
    ls "$VIRTUAL_ENV_DIR"
    return "$?"
}

## For when I want to create it in the same folder I am in
alias venv_create_local='python -m venv venv'
# (Assumes that you are in the directory of the virtual environmet)
alias venv_activate_local='source venv/bin/activate'
