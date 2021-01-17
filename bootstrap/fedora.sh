#!/usr/bin/env bash

PKGS=(
  bind-utils
  buildah
  curl
  exfat-utils
  fzf
  git
  gnupg
  golang-bin
  google-go-mono-fonts
  gron
  jetbrains-mono-fonts
  jq
  mosh
  msmtp
  nmap
  opensc
  parallel
  pass
  ripgrep
  screen
  ShellCheck # case sensitive
  tcptraceroute
  tmux
  tor
  vim-enhanced
  wireguard-tools
  xz
  yubikey-manager
  yubioath-desktop
  zsh
  zstd
)

# RPM Fusion
for repo in free nonfree; do
  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/${repo}/fedora/rpmfusion-${repo}-release-$(rpm -E %fedora).noarch.rpm"
done

sudo dnf update -y
sudo dnf install -y "${PKGS[@]}"

# Chrome
sudo tee /etc/yum.repos.d/google-chrome-beta.repo > /dev/null <<-EOF
	[google-chrome-beta]
	name=google-chrome-beta
	baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
	enabled=1
	gpgcheck=1
	gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
sudo dnf install -y google-chrome-beta

# 1Password
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo tee /etc/yum.repos.d/1password.repo > /dev/null <<-EOF
	[1password]
	name=1Password
	baseurl=https://downloads.1password.com/linux/rpm
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF
sudo dnf install -y 1password

# .dotfiles
git clone https://github.com/bdd/.dotfiles ~/.dotfiles
~/.dotfiles/mklink all
vim --cmd 'call install#("qall")'

# maps caps to ctrl
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"

# solid black background
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.background picture-uri ''

# switch to zsh
sudo usermod -s /usr/bin/zsh "$(whoami)" && exec zsh -li
