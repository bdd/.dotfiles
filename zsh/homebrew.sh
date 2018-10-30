# shellcheck shell=bash
if [[ $OSTYPE =~ darwin.* ]]; then
  # Under macOS we expect Homebrew to be installed under /usr/local and
  # /usr/local/bin to be in PATH, hence the `hash` check.
  if hash brew 2>/dev/null; then _has_brew=1; else return; fi

  export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
elif [[ $OSTYPE =~ linux.* ]] ; then
  _linuxbrew="/home/linuxbrew/.linuxbrew"
  if [[ -x "${_linuxbrew}/bin/brew" ]]; then _has_brew=1; else return; fi

  export PATH="${_linuxbrew}/bin:${PATH}"
  export MANPATH="${_linuxbrew}/share/man:${MANPATH}"
  export INFOPATH="${_linuxbrew}/share/info:${INFOPATH}"

  unset _linuxbrew
fi

if [[ ${_has_brew} ]]; then
  alias b=brew

  export HOMEBREW_NO_EMOJI=1
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_GITHUB_API=1

  # Load completion files
  if [[ -n "${ZSH_VERSION}" ]]; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:${FPATH}
  elif [[ -n "${BASH_VERSION}" ]]; then
    for _completion_file in "$(brew --prefix)"/etc/bash_completion.d/*; do
      # shellcheck source=/dev/null # don't follow to check sourced files.
      source "${_completion_file}"
    done
    unset _completion_file
  fi

  unset _has_brew
fi
