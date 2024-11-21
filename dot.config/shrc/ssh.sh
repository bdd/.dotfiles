# shellcheck shell=bash

ssh:gpg.rc() {
  # Consider calling this from ~/.(ba|z)shrc.local
  if hash gpg-connect-agent 2>/dev/null; then
    gpg-connect-agent /bye
    ssh:restore-gpg-agent
  fi
}

ssh:darwin.rc() {
  local ssh_bin="$(whence -p ssh)"
  case "${ssh_bin}" in
    "${HOME}/.nix-profile/bin/ssh" | /usr/local/bin/ssh | /opt/homebrew/bin/ssh)
      ssh:restore-ssh-agent || eval "$(ssh-agent)"
      ;;
    /usr/bin/ssh)
      # No FIDO2. PGP or PIV.
      # Default to using GPG
      ssh:gpg.rc
      ;;
    *)
      echo "${ssh_bin}?"
      ;;
  esac
}

ssh:_set-ssh_auth_sock() {
  [[ -n $1 && -S $1 ]] || return 1
  export SSH_AUTH_SOCK="$1"
}

ssh:restore-gpg-agent() {
  ssh:_set-ssh_auth_sock \
    "$(gpgconf --list-dirs agent-ssh-socket)"
}

ssh:restore-keyring-agent() {
  local s="${XDG_RUNTIME_DIR}/keyring/ssh"
  if [[ -r ${s} ]]; then
    ssh:_set-ssh_auth_sock "${s}"
  else
    return 69 # EX_UNAVAILABLE
  fi
}

ssh:restore-ssh-agent() {
  # "Why not just use lsof instead?"
  # ssh-agent disables ptrace on all platforms[1] leading to different
  # side effects across operating systems.
  #
  # On Linux this causes /proc/<pid>/* files to be only readable by root,
  # so unprivileged user cannot see the Unix domain socket paths of the
  # processes owned by themselves.
  #
  # [1]: https://git.io/J1Ugs

  local s sockets=() listeners=()
  IFS=$'\n' sockets+=( \
    $(find -E "${TMPDIR-/tmp}" -type s -uid "$(id -u)" -regex "${TMPDIR-/tmp}/ssh-.[^/]+/agent\.[0-9]+" 2>/dev/null) \
  )
  for s in "${sockets[@]}"; do
    # can we connect to this socket or is it a leftover?
    if nc -U "${s}" < /dev/null; then
      listeners+=("${s}")
    fi
  done

  local n=${#listeners[@]}
  if ! ((n == 1)); then
    if [[ ${n} -gt 1 ]]; then
      echo "more than one eligible listener: ${n}" >&2
    fi
    return 1
  fi

  # "Why loop here?"
  # Zsh's 1-indexed arrays vs Bash's 0-indexed arrays.
  # ...and if we made it here, array size is 1.
  for s in "${listeners[@]}"; do
    ssh:_set-ssh_auth_sock "${s}"
  done
}

case "${OSTYPE}" in
  darwin*)
    declare -r SC_PKCS11_PROVIDER=/usr/lib/ssh-keychain.dylib
    ;;

  linux*)
    _dirs=(
      /usr/lib64/pkcs11  # fedora
      /usr/lib/x86_64-linux-gnu  # debian
    )

    for _dir in "${_dirs[@]}"; do
      _so="${_dir}/opensc-pkcs11.so"
      if [[ -r "${_so}" ]]; then
        declare -r SC_PKCS11_PROVIDER="${_so}"
        unset _so
      fi

      _so="${_dir}/libtpm2_pkcs11.so"
      if [[ -r "${_so}" ]]; then
        declare -r TPM_PKCS11_PROVIDER="${_so}"
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
