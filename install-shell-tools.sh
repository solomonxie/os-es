#!/usr/bin/env bash
# Clone the public config repos and run each one's install.sh, which links it into ~/.config. Safe to re-run.
set -euo pipefail

clone_and_install() {  # clone_and_install <repo> <dest>
  [ -d "$2" ] || git clone "https://github.com/solomonxie/$1.git" "$2"
  "$2/install.sh"
}

clone_and_install vim-for-speed ~/.config/nvim
clone_and_install shells-on-shells ~/.config/shells-on-shells
clone_and_install tmux-ing ~/.config/tmux
