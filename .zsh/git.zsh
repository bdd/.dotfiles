typeset -a GIT_LOCATIONS
: ${ZSH_COLORS_GIT_CURRENT_BRANCH_PREFIX="<%{$fg[green]%}"}
: ${ZSH_COLORS_GIT_CURRENT_BRANCH_SUFFIX="%{$reset_color%}>"}

git_current_branch() {
  local branch

  # Do we have git?
  hash git 2> /dev/null || return

  # Is this directory in the whitelist?
  for loc in $GIT_LOCATIONS; do
    if [[ $PWD =~ $loc ]]; then
      ref=$(git symbolic-ref HEAD 2>/dev/null)
      if [[ $? -eq 0 ]]; then
        branch=${ref#refs/heads/}
      else
        # Is this actually a git repository?
        retval=$(git rev-parse 2>/dev/null)
        if [[ $? -eq 0 ]]; then
          branch="(detached)"
        else
          branch="!"
        fi
      fi

      printf "%s%s%s" \
        ${ZSH_COLORS_GIT_CURRENT_BRANCH_PREFIX} \
        $branch \
        ${ZSH_COLORS_GIT_CURRENT_BRANCH_SUFFIX}

    fi
  done

}

git_locations() {
  local edit=0
  local dir

  if [[ $# == 0 ]]; then
    echo $GIT_LOCATIONS
    return
  fi

  while [[ $# != 0 ]]; do
    case $1 in
      -e)
        edit=1
        shift
        ;;
      *)
        dir=${1:a} # 'a': Turn into absolute path
        if [[ -d $dir ]]; then
          # If not already in GIT_LOCATIONS
          if [[ -z ${GIT_LOCATIONS[(r)$dir]} ]]; then
            GIT_LOCATIONS+=($dir)
          fi
        else
          echo "No such directory: $dir" 2>&1
          return 1
        fi
        shift
        ;;
    esac
  done

  if [[ $edit == 1 ]]; then vared GIT_LOCATIONS; fi
}

git_checkout_branch_fuzzy() {
  local match="$(git rev-parse --abbrev-ref --branches="*$1*")"
  case $(wc -w <<< "${match}" | tr -d ' ') in
    "0")
      echo "error: '$1' did not match any branch." >&2
      return 1
      ;;
    "1")
      git checkout ${match}
      ;;
    *)
      echo "error: '$1' is ambiguous among:\n${match}" >&2
      return 1
      ;;
  esac
}

alias g=git
alias gl=git_locations
alias gle='git_locations -e'
alias gcb=git_checkout_branch_fuzzy
