# shellcheck shell=bash
export PYTHONSTARTUP=~/.config/python/startup
if [[ ! -r "${PYTHONSTARTUP}" ]]; then
  unset PYTHONSTARTUP
fi

alias py=python
