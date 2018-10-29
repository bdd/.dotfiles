# shellcheck shell=bash
# vim: filetype=sh

## Options
_shopts=(
  autocd # like zsh
  checkhash # check hash table before path search
  checkjobs # check running jobs when exiting interactive shell
  checkwinsize # update LINES and COLUMNS after every command
  cmdhist # save all lines of multi-line commands
  globstar # enable '**' expansion
  histappend # append to history
  histreedit # enable re-edit failed history substitution
  huponexit # SIGHUP all jobs on exit
  lithist # save multi line comments to history with new lines
  nullglob # allow file name patterns expanding to null
  promptvars # parameter expand in prompt string
)
shopt -s "${_shopts[@]}"; unset _shopts

## Aliases
alias h=history
alias utc='date -u "+%Y-%m-%dT%H:%MZ"'

if [[ $OSTYPE =~ darwin* ]]; then
  alias ls='ls -FG'
elif [[ $OSTYPE =~ linux* ]]; then
  alias ls='ls -F --color=auto'
fi

## Key Bindings
bind '"\C-G":insert-comment'

## Environment Variables
# History
export HISTCONTROL='ignorespace:ignoredups'
export HISTIGNORE='cd:cd -:cd ..:pwd:bg:fg:clear:mount'
export HISTFILESIZE=2000

## Prompt
export PS1='\w\$ '

# LS_COLORS Generator: http://geoff.greer.fm/lscolors/
# BSD: LSCOLORS | Linux: LS_COLORS
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Pick the available EDITOR in order of preference.
# For commands found, `whence` will print out the resolved paths or value of alias or function name.
# Remember: "Ed is the standard text editor." --ed(1)
EDITOR=$(command -v vim vi ed | head -n 1)
export EDITOR

## Extensions
# Load dual shell RC extensions from '~/.zsh' and ~/.bashrc.local
for _ext in ~/.zsh/*.sh ~/.bashrc.loca[l]; do
  # shellcheck source=/dev/null # don't follow to check sourced files.
  source "${_ext}"
done
unset _ext
