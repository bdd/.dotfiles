# shellcheck shell=bash

# Pick the available EDITOR in order of preference.
# For commands found, `whence` will print out the resolved paths or value of alias or function name.
# Remember: "Ed is the standard text editor." --ed(1)
whence_or_type="whence"
[[ -n "${BASH_VERSION-}" ]] && whence_or_type="type"

_editor=$(${whence_or_type} -p vim vi ed | head -n 1)

if [[ -n ${_editor} ]]; then
  export EDITOR=${_editor} VISUAL=${_editor}
fi
unset _editor
