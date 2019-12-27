# shellcheck shell=bash
# macOS only
[[ $OSTYPE =~ ^darwin ]] || return

ssh:gpg.rc() {
  # Consider calling this from ~/.(ba|z)shrc.local
  if hash gpg-connect-agent 2>/dev/null; then
    gpg-connect-agent /bye
    typeset -gr LAUNCHD_SSH_AUTH_SOCK=${SSH_AUTH_SOCK}
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  fi
}

typeset -gr MACOS_PKCS11_PROVIDER=/usr/lib/ssh-keychain.dylib
ssh:sc-add() {
  ssh-add -s "${MACOS_PKCS11_PROVIDER}"
}

ssh:sc-kill() {
  ssh-add -e "${MACOS_PKCS11_PROVIDER}"
}
