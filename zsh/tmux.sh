# shellcheck shell=bash
# vim: filetype=sh

# Don't continue evaluating this file if not running under tmux.
[[ -z "${TMUX}" ]] || return

tmux:refresh-env() {
  # '-s' option outputs Bourne-compatible unset/export commands.
  # It was added in tmux 2.1 (released 18 Oct 2015)
  eval $(tmux show-environment -s)
}
