# ZSH only
any () {
  if [[ -n "$1" ]]; then
    # convert 'thing' to '[t]hing' for 'ps | grep [t]hing' trick
    search=$(sed 's/./[&]/' <<< "$1")
    replace='&'

    # colorize match if stdout is a terminal, and supports 8 or more colors
    if [[ -t 1 && $(tput colors) -ge 8 ]]; then
      color=$'\e[0;31m'  # red
      reset=$'\e[0m'
      replace="${color}${replace}${reset}"
    fi

    # print header (first line) of 'ps' and matches
    ps auxwww | sed -n "1p; s/${search}/${replace}/gp"
  else
    return 64 # EX_USAGE
  fi
}
