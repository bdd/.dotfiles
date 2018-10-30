# shellcheck shell=bash
if [[ ${OSTYPE} =~ darwin* ]]; then
  _candidates="${HOME}/Applications /Applications /usr/local/opt/emacs"

  for _loc in ${_candidates}; do
    if [[ -d ${_loc}/Emacs.app ]]; then
      # shellcheck disable=SC2034 # EMACSAPP is not unused
      EMACSAPP="open -a ${_loc}/Emacs.app --args"
    fi
  done

  unset _candidates _loc
fi

alias e='emacsclient --no-wait'
alias edbginit='${EMACSAPP-emacs} --debug-init'
