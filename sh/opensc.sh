# macOS only
[[ $OSTYPE =~ ^darwin ]] || return

PKCS11_SO=/usr/local/lib/opensc-pkcs11-hardlink.so

opensc:mklink() {
  ln /usr/local/lib/opensc-pkcs11.so ${PKCS11_SO}
}

opensc:ssh-add() {
  ssh-add -s ${PKCS11_SO}
}

opensc:ssh-kill() {
  ssh-add -e ${PKCS11_SO}
}
