# shellcheck shell=bash
[[ ${OSTYPE} =~ ^(darwin|linux) ]] || return

_move_to_path_head() {
  # Prepend or move arguments to head of $PATH
  local _p
  local _path=()
  local grep_args=('-v')

  for _p in "$@"; do _path+=("$_p"); grep_args+=('-e' "^$_p$"); done

  for _p in $(tr : '\n' <<< "${PATH}" | grep "${grep_args[@]}"); do
    _path+=("$_p")
  done

  PATH=$(IFS=:; echo "${_path[*]}")
}

# Where is Homebrew installed?
_prefixes=("${HOME}/.brew") # non standard, homedir installation
if [[ ${OSTYPE} =~ ^linux ]]; then
  _prefixes+=("/home/linuxbrew/.linuxbrew")
elif [[ ${OSTYPE} =~ ^darwin ]]; then
  _prefixes+=("/usr/local")
fi

for _prefix in "${_prefixes[@]}"; do
  _brew="${_prefix}/bin/brew"
  if [[ -x ${_brew} && ${_prefix} == $(${_brew} --prefix) ]]; then
    # Prepend bin and sbin directories under Homebrew prefix to PATH
    _move_to_path_head "${_prefix}/bin" "${_prefix}/sbin"

    # Set environment variables and modify PATHs
    export HOMEBREW_PREFIX="${_prefix}"
    export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}";
    export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";

    # macOS will deduce man page paths from the directory of executable but
    # Linux requires a bit more help.
    if [[ ${OSTYPE} =~ ^linux ]]; then
      export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"; # notice trailing colon
      export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}";
    fi

    break # We've found our install location and done with the setup
  fi
done
unset _prefixes _prefix _brew
unset -f _move_to_path_head

if [[ -n ${HOMEBREW_PREFIX+defined} ]]; then
  # Homebrew behavior options
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
  export HOMEBREW_NO_EMOJI=1
  export HOMEBREW_NO_INSECURE_REDIRECT=1
  export HOMEBREW_NO_GITHUB_API=1
  if [[ ${OSTYPE} =~ ^darwin ]]; then
    export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
  fi

  # Load completion files
  if [[ -n "${ZSH_VERSION-}" ]]; then
    FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
  elif [[ -n "${BASH_VERSION-}" ]]; then
    for _f in "${HOMEBREW_PREFIX}"/etc/bash_completion.d/*; do
      # shellcheck source=/dev/null # don't follow to check sourced files.
      source "${_f}"
    done
    unset _f
  fi
fi
