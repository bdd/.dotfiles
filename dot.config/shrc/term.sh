# shellcheck shell=bash

_term:osc() {
  printf "\e]%d;%s\a" "$1" "$2"
}

termclip() {
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
  #
  # - WezTerm
  #   https://wezfurlong.org/wezterm/escape-sequences.html#operating-system-command-sequences

  # /!\
  # The output of base64 has to be gapless (no space, \n, \r).
  # `base64` command on Linux and some BSDs may wrap at 72 chars.
  local b64
  if whence -p base64 >/dev/null; then
    b64=$(base64 | tr -d '\r\n')
  elif whence -p b64encode >/dev/null; then
    # For FreeBSD
    b64=$(b64encode -r - | tr -d '\r\n')
  else
    return 69 # EX_UNAVAILABLE
  fi

  _term:osc 52 "c;${b64}"
}

termnotif() {
  # Displays a notification on terminal.
  #
  # If exists, first argument is used as notification string, otherwise it
  # defaults to "Attention".

  _term:osc 9 "${1:-Attention}"
}

termtitle() {
  _term:osc 1 "$@"
}

case "${TERM_PROGRAM}" in
  "WezTerm")
    alias imgcat="wezterm imgcat"
    ;;
  "iTerm.app")
    alias imgcat="iterm2-imgcat"
    ;;
esac
