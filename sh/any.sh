# shellcheck shell=bash
any() {
  if [[ -n "$1" ]]; then
    # convert 'needle' to '[n]eedle' for 'ps | grep [n]eedle' trick
    local needle=$1
    local head=${needle:0:1} tail=${needle:1}

    # colorize match if stdout is a terminal, and supports 8 or more colors
    if [[ -t 1 && $(tput colors) -ge 8 ]]; then
      local color=$'\e[0;31m'  # red
      local reset=$'\e[0m'
      local replace="${color}&${reset}"
    fi

    # print header (first line) of 'ps' and matches
    ps auxwww | sed -n "1p; s/[${head}]${tail}/${replace}/gp"
  else
    return 64 # EX_USAGE
  fi
}
