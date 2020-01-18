# shellcheck shell=bash

# Pick the available EDITOR in order of preference.
# For commands found, `whence` will print out the resolved paths or value of alias or function name.
# Remember: "Ed is the standard text editor." --ed(1)
_editor=$(command -v vim vi ed | head -n 1)
if [[ -n ${_editor} ]]; then
  export EDITOR=${_editor} VISUAL=${_editor}
fi
unset _editor
