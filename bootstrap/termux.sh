#!/$PREFIX/bin/bash
set -euo pipefail

PKGS=(
  curl
  fzf
  git
  gnupg
  jq
  man
  mosh
  msmtp
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
exec zsh
