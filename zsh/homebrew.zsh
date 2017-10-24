if [[ $OSTYPE =~ darwin.* ]]; then
  if hash brew 2>/dev/null; then _has_brew=1; else return; fi

  _zsh_site_functions="$(brew --prefix)/share/zsh/site-functions"

  alias cask='brew cask'

  export HOMEBREW_CASK_OPTS='--appdir=~/Applications'
elif [[ $OSTYPE =~ linux.* ]] ; then
  _linuxbrew_dir="/home/linuxbrew/.linuxbrew"
  if [[ -d "${_linuxbrew_dir}" ]]; then _has_brew=1; else return; fi

  _zsh_site_functions="${_linuxbrew_dir}/completions/zsh"

  export PATH="${_linuxbrew_dir}/bin:$PATH"
  export MANPATH="${_linuxbrew_dir}/share/man:$MANPATH"
  export INFOPATH="${_linuxbrew_dir}/share/info:$INFOPATH"

  unset _linuxbrew_dir
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
