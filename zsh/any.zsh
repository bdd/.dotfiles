# ZSH only
any () {
  if [[ -z "$1" ]]; then
    return 64 # EX_USAGE
  else
    emulate -L zsh
    unsetopt KSH_ARRAYS
    # the scary looking string is for '| grep [t]hing' trick.
    ps auxwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
  fi
}
