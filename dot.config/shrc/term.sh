# shellcheck shell=bash

_term:osc() {
  local prefix="" suffix=""
  if [[ -n "${TMUX}" ]]; then
    prefix=$'\ePtmux;\e'
    suffix=$'\e\\'
  fi

  printf "%s\e]%d;%s\a%s" "${prefix}" "$1" "$2" "${suffix}"
}

termclip() {
  # Copies stdin to clipboard using OSC 52

  _term:osc 52 "c;$(base64 -w 0)"
}

termnotif() {
  # Displays a notification on terminal.
  #
  # If exists, first argument is used as notification string, otherwise it
  # defaults to hostname:{tty or tmux window index}.

  local msg

  if [[ $# -eq 0 ]]; then
    msg="$(hostname):"
    if [[ -n "${TMUX}" ]]; then
      msg+="tmux/$(tmux display-message -p -F '#{window_index}')"
    else
      msg+="${TTY}"
    fi
  else
    msg="$1"
  fi

  _term:osc 9 "${msg}"
  printf "\a"
}

termtitle() {
  _term:osc 0 "$@"
}

termresize() {
  local save
  save=$(stty -g)
  stty raw -echo min 0 time 5

  # Like OSC (]), but CSI ([).
  printf "\e[18t" > /dev/tty
  # shellcheck disable=SC2141 # yes, we really want to split on 't'.
  IFS=';t' read -r _ rows cols _ < /dev/tty

  stty "${save}"
  stty cols "${cols}" rows "${rows}"
}

case "${TERM_PROGRAM}" in
  "ghostty")
    alias imgcat="viu"
    ;;
  "WezTerm")
    alias imgcat="wezterm imgcat"
    ;;
  "iTerm.app")
    alias imgcat="iterm2-imgcat"
    ;;
esac
