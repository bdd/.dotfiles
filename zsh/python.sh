# shellcheck shell=bash
# vim: filetype=sh
export PYTHONSTARTUP=~/.config/python/startup
if [[ ! -r "${PYTHONSTARTUP}" ]]; then
  unset PYTHONSTARTUP
fi

alias py=python
