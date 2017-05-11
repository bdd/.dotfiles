extract () {
  local opt verbose test

  while getopts :vt opt; do
    case ${opt} in
      v)
        verbose="-${opt}" ;;
      t)
        test="-${opt}"    ;;
      \?)
        echo "Unrecognized option -${OPT}ARG"
        echo "Usage: $0 [-vt] <file>"
        return 1
    esac
  done

  shift $((OPTIND - 1))

  if [[ $# -lt 1 ]]; then return; fi

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
      unzip ${verbose} ${test} -q "$1" ;;
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
