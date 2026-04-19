# shellcheck shell=bash

if read -r _editor < <(command -v vim vi ed); then
  export EDITOR=${_editor} VISUAL=${_editor}
fi
unset _editor
