# shellcheck shell=bash
extract() {
  local verbose test

  if [[ -n "${BASH_VERSION-}" ]]; then local fn=${FUNCNAME[0]}; else local fn=$0; fi
  local __usage__="Usage: ${fn} [-vt] file"

  local opt OPTIND=1
  while getopts ':vt' opt; do
    case ${opt} in
      v) verbose="-${opt}" ;;
      t) test="-${opt}" ;;
      *)
        echo "Unrecognized option -${OPTARG}" >&2
        echo "${__usage__}" >&2
        return 64 # EX_USAGE
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if (($# == 0)); then
    echo "${__usage__}" >&2
    return 64 # EX_USAGE
  fi

  case "$1" in
    *.tgz|*.txz|*.tbz2)
      ;&
    *.tar.gz|*.tar.xz|*.tar.bz2)
      tar ${verbose} ${test:--x} -f "$1" ;;
    *.gz)
      gunzip ${verbose} ${test} "$1" ;;
    *.xz)
      xz ${verbose} ${test} -d "$1" ;;
    *.bz2)
      bunzip2 ${verbose} ${test} "$1" ;;
    *.zip)
      unzip ${verbose:--q} ${test+-l} "$1" ;;
    *.[jwe]ar)
      jar ${test:-x}${verbose+v}f "$1" ;;
    *.Z)
      uncompress "$1" ;;
    *.7z)
      7z x "$1" ;;
    *.safariextz)
      xar ${verbose} ${test:--x} -f "$1" ;;
    *)
      echo "Don't know how to extract '$1'" >&2;
      return 1
  esac
}

alias x=extract
