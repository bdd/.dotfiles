# Don't continue evaluating this file if not running under tmux.
if [[ -z ${TMUX} ]]; then return; fi

tmux:refresh-env() {
  IFS=$'\n'
  for ev in $(tmux show-environment); do
    if [[ ${ev[1]} == '-' ]]; then
      unset "${ev[2,${#ev}]}"  # remove '-' prefix
    else
      export "${ev}"
    fi
  done
}
