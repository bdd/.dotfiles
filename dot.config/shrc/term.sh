# shellcheck shell=bash
t_ST=$'\e\\'
t_OSC=$'\e]'
t_CSI=$'\e['
readonly t_ST t_OSC t_CSI

# Sends OSC escape sequences
#
# When running under Tmux, wraps them with passthrough sequences.
_term:osc() {
  local op=$1
  local payload=$2
  local seq="${t_OSC}${op};${payload}${t_ST}"

  if [[ -n ${TMUX-} ]]; then
    # Replace escape (sym=\e oct=033 hex=1b) with double escape in the seq.
    local escaped_seq=${seq//$'\e'/$'\e\e'}
    # Wrap between `\ePtmux;` and t_ST.
    printf '\ePtmux;%s%s' "${escaped_seq}" "${t_ST}"
  else
    printf '%s' "${seq}"
  fi
}

# Copies stdin to clipboard using OSC 52
termclip() {
  _term:osc 52 "c;$(base64 -w 0)"
}

# Displays a notification on terminal using OSC 9
#
# If exists, first argument is used as notification string, otherwise it
# defaults to hostname:{tty or tmux window index}.
termnotif() {
  local msg

  if [[ $# -eq 0 ]]; then
    msg="$(hostname):"
    if [[ -n ${TMUX-} ]]; then
      msg+="tmux"
      msg+=$(
        tmux display-message -p -F \
          '(#{session_name})[#{window_index}:#{window_name}].#{pane_index}'
      )
    else
      msg+="$(tty)"
    fi
  else
    msg="$1"
  fi

  _term:osc 9 "${msg}"
  printf '\a'
}

# Sets the window title
termtitle() {
  _term:osc 0 "$@"
}

# Resizes the remote terminal to fit into viewing terminal
#
# Useful for direct over SSH serial console connections which tend to default
# to 80x24.
termfit() {
  local save
  save=$(stty -g)
  stty raw -echo min 0 time 10
  #    ^^^ ^^^^^ ^^^^^ ^^^^^^^
  #     |    |     |      \__> read timeout=10 ds (1 s)
  #     |    |     \_________> read 0 chars: read timer starts immediately
  #     |    \_______________> disable echo
  #     \____________________> raw mode

  # CSI 18t: Report Terminal Size (https://terminalguide.namepad.de/seq/csi_st-18/)
  #     response: <CSI 8>;<rows>;<cols>t
  printf '%s' "${t_CSI}18t" > /dev/tty
  local csi8 rows cols
  IFS=';' read -r -dt csi8 rows cols < /dev/tty
  #               ^^^ input is terminated by 't' instead of a newline.
  # Not specifying the delim relies on tty read timeout.
  # Examples online (and naturally, LLMs) miss this and waste time.

  stty "${save}" # restore
  if [[ ${csi8} == ${t_CSI}8 ]]; then
    stty rows "${rows}" cols "${cols}" # fit
  else
    printf "Terminal didn't respond to CSI 18t as we expected.\n" >&2
    return 69 # EX_UNAVAILABLE
  fi
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
