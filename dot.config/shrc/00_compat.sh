# shellcheck shell=bash

# shellcheck disable=SC2034
if [[ -n "${BASH_VERSION-}" ]]; then
  alias whence=type
fi
