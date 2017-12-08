# [bdd]'s Vim #

## Version ##
Target version is Vim 8 on macOS and Linux.

## Installation ##
### Fix your xterm-256color first ###
macOS High Sierra still ships with a busted terminfo for `xterm-256color`.
It is missing escape codes for italics even though Terminal.app supports them.

I recommend patching instead of creating a variant.

```
% export TERM=xterm-256color
% {infocmp && echo -e '\tsitm=\E[3m, ritm=\E[23m,'} > ~/.$TERM-patched.terminfo && tic ~/.$TERM-patched.terminfo
```

Tmux with `set -g default-terminal xterm-256color` works as expected after
fixing terminfo.

#### A font family with italics ####
You won't see italics in the terminal if your choice of font family doesn't
have them.  Under macOS, Monaco—the default monospaced typeface, doesn't have
italics, but Menlo does.

I find [Go Mono family] to be delightful both in the terminal and GUI.  If you
use [Homebrew], you can install them from 'caskroom/fonts' Homebrew Tap.

```
% brew tap caskroom/fonts
% brew cask install font-go-mono
```

### Install third party plugins ###
Third party plugins are managed with [minpac], a minimal package manager for
Vim 8, using native support for packages.  It clones and updates plug-in
repositories from GitHub.

To bootstrap:

```
% vim --cmd 'call install#()'
```


[bdd]: https://bdd.fi
[Go Mono family]: https://blog.golang.org/go-fonts
[Homebrew]: https://brew.sh
[minpac]: https://github.com/k-takata/minpac
