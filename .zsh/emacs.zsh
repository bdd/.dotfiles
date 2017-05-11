if [[ ${OSTYPE} =~ darwin* ]]; then
  local candidates loc
  candidates=(~/Applications /Applications /usr/local/opt/emacs)

  for loc in ${candidates}; do
    if [[ -d ${loc}/Emacs.app ]]; then
      EMACSAPP="open -a ${loc}/Emacs.app --args"
    fi
  done
fi

alias e='emacsclient --no-wait'
alias edbginit="${EMACSAPP-emacs} --debug-init"
