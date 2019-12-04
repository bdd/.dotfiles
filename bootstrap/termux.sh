# shellcheck shell=bash

# Setup preferred environment in Termux
#
# Option 1: Execute
# Run `bash termux.sh` and when it finishes restart Termux for
#
# Option 2: Source
# Run `source termux.sh` to replace running bash with zsh at the end

if ((SHLVL > 1)); then
  # Be strict only when executing as a subshell.
  # We don't want to kill login shell for errors when we're `source`d
  set -euo pipefail
fi

PKGS=(
  curl
  fzf
  git
  gnupg
  jq
  man
  mosh
  msmtp
  ncurses-utils
  nmap
  openssh
  openssl-tool
  parallel
  python
  ripgrep
  tmux
  tor
  tracepath
  unrar
  vim
  xz-utils
  zsh
  zstd
)

apt update --quiet
apt install --quiet --yes "${PKGS[@]}"

# .dotfiles
git clone https://github.com/bdd/.dotfiles ~/.dotfiles
~/.dotfiles/mklink all
vim --cmd 'call install#()'

# intents and hooks
mkdir ~/bin
ln -s "${PREFIX}"/bin/vim ~/bin/termux-file-editor
# TODO: ~/bin/termux-url-opener

# switch to zsh
chsh -s zsh
((SHLVL == 1)) && exec zsh || echo "Ready to restart."
