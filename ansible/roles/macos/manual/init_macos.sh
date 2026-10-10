#!/usr/bin/env bash
# Manual equivalent of ansible/roles/macos — for reference, not execution.

# tasks/main.yml: formulas
brew install vim tmux zsh git wget ansible terraform awscli htop lua \
  lua-language-server reattach-to-user-namespace ripgrep telnet coreutils \
  mactop ruby cmake sqlite fd duckdb tig ffmpeg tree ncdu fzf \
  gnu-sed gnu-tar virtualenv python@3.12 python@3.13 python@3.14

# tasks/system_defaults.yml: macOS system settings
defaults write com.apple.screencapture location "$HOME/Downloads"
defaults write com.apple.screencapture disable-sound -bool true

# System language + locale: English (US)
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale -string "en_US"

# Keyboard: U.S. English first in the enabled list, so it is the login default
# (otherwise macOS starts in the Pinyin input method).
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
  '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }' \
  '{ "Bundle ID" = "com.apple.CharacterPaletteIM"; InputSourceKind = "Non Keyboard Input Method"; }' \
  '{ "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; }' \
  '{ "Bundle ID" = "com.apple.inputmethod.SCIM"; InputSourceKind = "Keyboard Input Method"; }' \
  '{ "Bundle ID" = "com.apple.inputmethod.SCIM"; "Input Mode" = "com.apple.inputmethod.SCIM.ITABC"; InputSourceKind = "Input Mode"; }'
defaults write com.apple.HIToolbox AppleSelectedInputSources -array \
  '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }' \
  '{ "Bundle ID" = "com.apple.PressAndHold"; InputSourceKind = "Non Keyboard Input Method"; }'
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.US"

killall SystemUIServer

# tasks/languages.yml: python/node virtualenvs
brew install virtualenv nodeenv
virtualenv -p python3.14 ~/virtualenv/venv
pip install nodeenv
nodeenv ~/virtualnode/venv
~/virtualenv/venv/bin/pip install -r ansible/roles/macos/tasks/requirements_py.txt

# tasks/neovim.yml: Neovim release (not Homebrew), version must match zsh/zshrc-mac.zsh PATH
NVIM_VERSION=0.11.2
NVIM_ARCH=arm64  # or x86_64 on Intel Macs
curl -Lo /tmp/nvim-macos-$NVIM_VERSION.tar.gz \
  https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-macos-$NVIM_ARCH.tar.gz
tar -xzf /tmp/nvim-macos-$NVIM_VERSION.tar.gz -C /tmp
mv /tmp/nvim-macos-$NVIM_ARCH ~/nvim-macos-$NVIM_VERSION
xattr -r -d com.apple.quarantine ~/nvim-macos-$NVIM_VERSION

# tasks/shell_tools.yml: shell packages + dotfile symlinks
brew install zsh tmux
ln -sf ~/myconf/ssh ~/.ssh
ln -sf ~/myconf/config ~/.config
ln -sf ~/myconf/os-es/etc/tigrc ~/.tigrc
ln -sf ~/myconf/os-es/etc/fd ~/myconf/config/fd
ln -sf ~/myconf/os-es/etc/pylintrc ~/myconf/config/pylintrc


touch ~/.vimrc-env.vim ~/.vimrc-local.vim ~/.global.env
cp ~/myconf/os-es/etc/git/gitconfig-init.ini ~/.gitconfig

# tasks/iterm2.yml: live-sync prefs folder + font
defaults write com.googlecode.iterm2 PrefsCustomFolder -string ~/myconf/os-es/ansible/roles/macos/iterm2/prefs
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
curl -L -o ~/Library/Fonts/DroidSansMNerdFont-Regular.otf \
  https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
# then relaunch iTerm2 once to pull in the tracked prefs (or General > Preferences
# > "Save Settings to Folder Now" the other direction, to seed it initially)

# tasks/repos.yml: public config repos, each linking itself into place
for repo in svimmer coastal-shells tmuxedo llm-collections; do
  [ -d ~/myconf/$repo ] || git clone https://github.com/solomonxie/$repo.git ~/myconf/$repo
  ~/myconf/$repo/install.sh
done

# tasks/llm.yml
brew install ollama
