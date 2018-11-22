# shellcheck shell=bash
whence -p brew > /dev/null || return

export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_GITHUB_API=1
if [[ $OSTYPE =~ darwin.* ]]; then
  export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
fi

# Load completion files
if [[ -n "${ZSH_VERSION}" ]]; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:${FPATH}
elif [[ -n "${BASH_VERSION}" ]]; then
  for _f in "$(brew --prefix)"/etc/bash_completion.d/*; do
    # shellcheck source=/dev/null # don't follow to check sourced files.
    source "${_f}"
  done
  unset _f
fi
