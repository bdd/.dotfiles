# shellcheck shell=bash

nixdev:github-ref-hash() {
  local user=$1 repo=$2 ref=$3
  if [[ -z ${user-} || -z ${repo-} || -z ${ref-} ]]; then
    echo "usage: nixhelp:github-ref-hash user repo ref" >&2
    return 1
  fi
  local url="https://github.com/${user}/${repo}/archive/${ref}.tar.gz"
  nix hash to-sri sha256:"$(nix-prefetch-url --unpack "${url}")"
}
