# shellcheck shell=bash
if [[ $OSTYPE =~ darwin* ]]; then
  alias ls='ls -FG'
elif [[ $OSTYPE =~ linux* ]]; then
  alias ls='ls -F --color=auto'
fi

# LS_COLORS Generator: http://geoff.greer.fm/lscolors/
# BSDs: LSCOLORS, Linux: LS_COLORS
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

if [[ -n "${ZSH_VERSION}" ]]; then
  # Use LS_COLORS on completion prompts too
  zmodload -i zsh/complist
  zstyle ':completion:*' list-colors ${(s/:/)LS_COLORS}
fi
