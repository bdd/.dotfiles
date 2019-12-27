# shellcheck shell=bash
# macOS only
[[ $OSTYPE =~ ^darwin ]] || return

typeset -gr MACOS_PKCS11_PROVIDER=/usr/lib/ssh-keychain.dylib
ssh:sc-add() {
  ssh-add -s "${MACOS_PKCS11_PROVIDER}"
}

ssh:sc-kill() {
  ssh-add -e "${MACOS_PKCS11_PROVIDER}"
}
