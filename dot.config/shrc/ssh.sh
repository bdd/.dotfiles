# shellcheck shell=bash

ssh:gpg.rc() {
  # Consider calling this from ~/.(ba|z)shrc.local
  if hash gpg-connect-agent 2>/dev/null; then
    gpg-connect-agent /bye
    if [[ ${OSTYPE} =~ ^darwin ]]; then
      typeset -gr LAUNCHD_SSH_AUTH_SOCK=${SSH_AUTH_SOCK}
    fi
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  fi
}


case "${OSTYPE}" in
  darwin*)
    typeset -gr PKCS11_PROVIDER=/usr/lib/ssh-keychain.dylib
    ;;

  linux*)
    _dirs=(
      /usr/lib64/pkcs11  # fedora
      /usr/lib/x86_64-linux-gnu  # debian
    )

    for _dir in ${_dirs[@]}; do
      _so="${_dir}/opensc-pkcs11.so"
      if [[ -r "${_so}" ]]; then
        typeset -gr PKCS11_PROVIDER="${_so}"
        unset _so
      fi
    done

    unset _dir _dirs
    ;;

  *)
    return 0
esac

ssh:sc-add() {
  ssh-add -s "${PKCS11_PROVIDER}"
}

ssh:sc-kill() {
  ssh-add -e "${PKCS11_PROVIDER}"
}
