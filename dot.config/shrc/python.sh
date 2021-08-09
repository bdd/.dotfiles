# shellcheck shell=bash
export PYTHONSTARTUP=${XDG_CONFIG_HOME:-${HOME}/.config}/python/startup
[[ -r ${PYTHONSTARTUP} ]] || unset PYTHONSTARTUP

_prefer_py3() {
  if hash python3; then python3 "$@"; else python "$@"; fi
}

alias python=_prefer_py3
alias py=python
