# vim: filetype=zsh
#
# We only set exported environment variables here, thus no need to continue
# evaluation under a nested shell.
if [[ $SHLVL -gt 1 ]]; then return; fi

# Build PATH on top of a preferred list and append directories from pre-RC
# evaluation PATH variable.
# - On macOS /etc/zprofile invokes 'path_helper' to source entries under
#   /etc/paths.d/.
# - On rather esoteric environments like SDFs NetBSD, Termux, etc. many
#   non-standard directories will be put into path by either GLOBAL_RCS or
#   specific login implementation.
readonly PRE_RC_PATH=$PATH
_path=(/usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin)

# Word split colon separated list
for dir in ${(s/:/)PRE_RC_PATH}; do
  # Append directories which are not already in preferred array.
  # `${arr[(r)ent]}` expands to 'ent' if it's in 'arr'; else to empty string.
  if [[ -z ${_path[(r)$dir]} ]]; then
    _path+=(${dir})
  fi
done

# Array to colon separated list
PATH=${(j/:/)_path}; unset _path

# Linuxbrew
if [[ ${OSTYPE} =~ linux.* ]]; then
  _linuxbrew="/home/linuxbrew/.linuxbrew"
  if [[ -x "${_linuxbrew}/bin/brew" ]]; then
    export PATH="${_linuxbrew}/bin:${_linuxbrew}/sbin:${PATH}"
    export MANPATH="${_linuxbrew}/share/man${MANPATH+:$MANPATH}"
    export INFOPATH="${_linuxbrew}/share/info${INFOPATH+:$INFOPATH}"
  fi
  unset _linuxbrew
fi

# Pick the available EDITOR in order of preference.
# For commands found, `whence` will print out the resolved paths or value of alias or function name.
# Remember: "Ed is the standard text editor." --ed(1)
export EDITOR=$(whence vim vi ed | head -n 1)
