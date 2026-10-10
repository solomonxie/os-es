#!/usr/bin/env bash
# Symlink the shared CLI configs in etc/ into place. Existing symlinks are replaced; real files are moved to <path>.bak.<timestamp>.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)

link() {  # link <path in repo> <dest>
  local src=$here/$1 dest=$2
  [ "$src" -ef "$dest" ] && return
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"; fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

link etc/tigrc ~/.tigrc
link etc/fd ~/.config/fd
link etc/pylintrc ~/.config/pylintrc
# Files, not the folder: ~/.config/git also holds git's own global ignore file.
link etc/git/gitconfig-extra.ini ~/.config/git/gitconfig-extra.ini
link etc/git/git-commit-template.txt ~/.config/git/git-commit-template.txt
link etc/git/hooks ~/.config/git/hooks

# Copied, not linked: git writes name/email into it.
[ -e ~/.gitconfig ] || { cp "$here/etc/git/gitconfig-init.ini" ~/.gitconfig; echo "copied ~/.gitconfig"; }
