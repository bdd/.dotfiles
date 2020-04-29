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

## Key Bindings
bind '"\C-G":insert-comment'

## XDG
[[ -d "${XDG_CONFIG_HOME:=${HOME}/.config}" ]] || mkdir "${XDG_CONFIG_HOME}"
[[ -d "${XDG_CACHE_HOME:=${HOME}/.cache}" ]] || mkdir "${XDG_CACHE_HOME}"
[[ -d "${XDG_DATA_HOME:=${HOME}/.local/share}/bash" ]] || mkdir -p "${XDG_DATA_HOME}/bash"

## Bash Variables
HISTFILE="${XDG_DATA_HOME}/bash/history"
HISTCONTROL='ignorespace:ignoredups'
HISTIGNORE='cd:cd -:cd ..:pwd:bg:fg:clear:mount'
HISTFILESIZE=2000

## Prompt
PS1='\w\$ '

## Extensions
# Load: ~/.config/shrc/*.bash, ~/.config/shrc/*.sh, and ~/.bashrc.local
for _ext in "${XDG_CONFIG_HOME}"/shrc/*.{ba,}sh ~/.bashrc.loca[l]; do
  # shellcheck source=/dev/null # don't follow to check sourced files.
  source "${_ext}"
done
unset _ext
