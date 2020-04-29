# ZSH only
# usage: .. [n]
# Go `n' directories up.
# `n' defaults to 1, staying compatible with `setopt AUTO_CD'.
cd2 () {
  cd ${(r:3 * ${1-1}::../:)}
}

alias ..=cd2
