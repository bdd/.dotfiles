# shellcheck shell=bash
[[ ${OSTYPE} =~ ^(darwin|linux) ]] || return 0

__cache_homebrew_prefix=~/.cache/homebrew-prefix

_find_homebrew_install() {
  local prefixes=("${HOME}/.brew") # non standard, homedir install
  if [[ ${OSTYPE} =~ ^darwin ]]; then
    prefixes+=("/usr/local")
  elif [[ ${OSTYPE} =~ ^linux ]]; then
    prefixes+=("/home/linuxbrew/.linuxbrew")
  fi

  local prefix
  for prefix in "${prefixes[@]}"; do
    local brew="${prefix}/bin/brew"
    if [[ -x ${brew} && ${prefix} == $(${brew} --prefix) ]]; then
      echo "${prefix}"
      return
    fi
  done
}

_setup_homebrew() {
  # Set environment variables
  export HOMEBREW_PREFIX="$1"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}";
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";

  # Update prefix cache
  ln -sf "${HOMEBREW_PREFIX}" "${__cache_homebrew_prefix}"

  # Homebrew behavior
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
  export HOMEBREW_NO_EMOJI=1
  export HOMEBREW_NO_INSECURE_REDIRECT=1
  export HOMEBREW_NO_GITHUB_API=1
  if [[ ${OSTYPE} =~ ^darwin ]]; then
    export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
  fi

  # Add to PATHs
  _move_to_path_head "${HOMEBREW_PREFIX}/bin" "${HOMEBREW_PREFIX}/sbin"

  # macOS will deduce man page paths from the directory of executable but
  # Linux requires a bit more help.
  if [[ ${OSTYPE} =~ ^linux ]]; then
    export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"; # notice trailing colon
    export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH+:$INFOPATH}";
  fi

  # Load completion files
  if [[ -n "${ZSH_VERSION-}" ]]; then
    FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
  elif [[ -n "${BASH_VERSION-}" ]]; then
    local cf
    for cf in "${HOMEBREW_PREFIX}"/etc/bash_completion.d/*; do
      # shellcheck source=/dev/null # don't follow to check sourced files.
      source "${cf}"
    done
  fi
}

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

_brew_placeholder () {
  if [[ -n $1 && $1 == "bootstrap" ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" 
    return
  fi

  local prefix=$(_find_homebrew_install)
  if [[ -n ${prefix} ]]; then
    _setup_homebrew "${prefix}"
    unalias brew
  else
    echo 'Use `brew bootstrap` to install Homebrew.'
  fi
}

if [[ -L ${__cache_homebrew_prefix} ]]; then
  _cached_prefix=$(readlink "${__cache_homebrew_prefix}")
  if [[ -d ${_cached_prefix} ]]; then
    _setup_homebrew "${_cached_prefix}"
  fi
else
    alias brew="_brew_placeholder"
fi
