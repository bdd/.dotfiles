# shellcheck shell=bash
dns-flush() {
  if [[ $OSTYPE =~ ^darwin ]]; then
    sudo killall -HUP mDNSResponder
    sudo killall mDNSResponderHelper
    sudo dscacheutil -flushcache
  else
    echo "Not implemented on ${OSTYPE} yet." >&2
  fi
}
