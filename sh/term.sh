# shellcheck shell=bash

term:tmux_dcs() {
  printf '\ePtmux;\e'; cat; printf '\e\\'
}


term:clip() {
  # Copies stdin to terminal hosts's clipboard using OSC 52 escape sequences.
  #
  # Support for OSC 52 as of Dec 2019
  # - iTerm2 on macOS
  #   User needs to give access to clipboard.
  #   Only implements write access: https://github.com/gnachman/iTerm2/blob/4e55c33c9ea93f93a813da640d89c9e0fde7e3ec/sources/VT100Terminal.m#L1084
  #
  # - hterm on Chrome OS
  #   Write access is enabled by default, read access needs to be enabled.
  #   Supports a bunch more OSC escape sequences https://chromium.googlesource.com/apps/libapps/+/master/hterm/doc/ControlSequences.md#OSC

  # /!\
  # The output of base64 has to be gapless (no space, \n, \r).
  # `base64` command on Linux and some BSDs may wrap at 72 chars.
  local b64
  if hash base64 2>/dev/null; then
    b64=$(base64 | tr -d '\r\n')
  elif hash b64encode 2>/dev/null; then
    # For FreeBSD
    b64=$(b64encode -r - | tr -d '\r\n')
  else
    return 69 # EX_UNAVAILABLE
  fi

  print "\e]52;c;%s\a" "${b64}"
}

termclip() {
  if [[ -n "${TMUX}" ]]; then term:clip | term:tmux_dcs; else term:clip; fi
}


term:notif() {
  # Displays a notification on terminal.
  #
  # If exists, first argument is used as notification string, otherwise it
  # defaults to "Attention".

  printf "\e]9;%s\a" "${1:-Attention}"
}

termnotif() {
  if [[ -n "${TMUX}" ]]; then term:notif "$@" | term:tmux_dcs; else term:notif "$@"; fi
}
