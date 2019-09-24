# macOS only
[[ $OSTYPE =~ ^darwin ]] || return

PKCS11_SO_ORIG=/usr/local/lib/opensc-pkcs11.so
PKCS11_SO_LINK=/usr/local/lib/opensc-pkcs11-hardlink.so

opensc:mklink() {
  ln ${PKCS11_SO_ORIG} ${PKCS11_SO_LINK}
}

opensc:update-link() {
  if [[ -e ${PKCS11_SO_ORIG} && -e ${PKCS11_SO_LINK} ]]; then
    if ! cmp --quiet ${PKCS11_SO_LINK} ${PKCS11_SO_ORIG}; then
      rm ${PKCS11_SO_LINK}
      opensc:mklink
    else
      # no update needed
      return 1
    fi
  else
    # origin or the link file doesn't exist
    return 66 # EX_NOINPUT
  fi
}

opensc:ssh-add() {
  ssh-add -s ${PKCS11_SO_LINK}
}

opensc:ssh-kill() {
  ssh-add -e ${PKCS11_SO_LINK}
}
