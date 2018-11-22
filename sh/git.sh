# shellcheck shell=bash
git-checkout-branch-fuzzy() {
  local match
  match="$(git rev-parse --abbrev-ref --branches="*$1*")"
  case $(wc -w <<< "${match}" | tr -d ' ') in
    "0")
      echo "error: '$1' did not match any branch." >&2
      return 1
      ;;
    "1")
      git checkout "${match}"
      ;;
    *)
      print "err: '%s' is ambiguous among:\n%s" "$1" "${match}" >&2
      return 1
      ;;
  esac
}

alias g=git
alias gcb=git-checkout-branch-fuzzy
