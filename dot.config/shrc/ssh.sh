# shellcheck shell=bash

ssh:gpg.rc() {
  # Consider calling this from ~/.(ba|z)shrc.local
  if hash gpg-connect-agent 2>/dev/null; then
    gpg-connect-agent /bye
    ssh:restore-gpg-agent
  fi
}

ssh:_set-ssh_auth_sock() {
  [[ -n $1 && -S $1 ]] || return 1
  export SSH_AUTH_SOCK="$1"
}

ssh:restore-gpg-agent() {
  ssh:_set-ssh_auth_sock \
    "$(gpgconf --list-dirs agent-ssh-socket)"
}

ssh:restore-ssh-agent() {
  ssh:_set-ssh_auth_sock \
    "$(lsof -a -U -u "${USER}" -c ssh-agent -Fn | sed -n 's/^n//p')"
}

case "${OSTYPE}" in
  darwin*)
    typeset -gr SC_PKCS11_PROVIDER=/usr/lib/ssh-keychain.dylib
    ;;

  linux*)
    _dirs=(
      /usr/lib64/pkcs11  # fedora
      /usr/lib/x86_64-linux-gnu  # debian
    )

    for _dir in "${_dirs[@]}"; do
      _so="${_dir}/opensc-pkcs11.so"
      if [[ -r "${_so}" ]]; then
        typeset -gr SC_PKCS11_PROVIDER="${_so}"
        unset _so
      fi

      _so="${_dir}/libtpm2_pkcs11.so"
      if [[ -r "${_so}" ]]; then
        typeset -gr TPM_PKCS11_PROVIDER="${_so}"
        unset _so
      fi
    done

    unset _dir _dirs
    ;;

  *)
    return 0
esac

if [[ -n ${SC_PKCS11_PROVIDER-} ]]; then
  ssh:sc-add() {
    ssh-add -s "${SC_PKCS11_PROVIDER}"
  }

  ssh:sc-kill() {
    ssh-add -e "${SC_PKCS11_PROVIDER}"
  }
fi

if [[ -n ${TPM_PKCS11_PROVIDER-} ]]; then
  ssh:tpm-add() {
    ssh-add -s "${TPM_PKCS11_PROVIDER}"
  }

  ssh:tpm-kill() {
    ssh-add -e "${TPM_PKCS11_PROVIDER}"
  }
fi
