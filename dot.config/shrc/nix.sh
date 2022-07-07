# shellcheck shell=bash

nixhelp:github-ref-hash() {
  local user=$1 repo=$2 ref=$3
  local url="https://github.com/${user}/${repo}/archive/${ref}.tar.gz"
  nix hash to-sri sha256:"$(nix-prefetch-url --unpack "${url}")"
}
