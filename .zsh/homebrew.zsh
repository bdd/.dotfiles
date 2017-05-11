if [[ $OSTYPE =~ darwin.* ]]; then
  if hash brew 2>/dev/null; then _has_brew=1; else return; fi

  _zsh_site_functions="$(brew --prefix)/share/zsh/site-functions"

  alias cask='brew cask'

  export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
elif [[ $OSTYPE =~ linux.* ]] ; then
  if [[ -d ~/.linuxbrew/bin ]]; then _has_brew=1; else return; fi

  _zsh_site_functions=~/.linuxbrew/completions/zsh

  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi


if [[ ${_has_brew} ]]; then
  alias b=brew

  export HOMEBREW_NO_EMOJI=1
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_GITHUB_API=1

  if [[ -d "${_zsh_site_functions}" ]]; then
    fpath=("${_zsh_site_functions}" $fpath)
  fi

  unset _has_brew
  unset _zsh_site_functions
fi
