#!/usr/bin/env bash
# Manual equivalent of ansible/roles/macos — for reference, not execution.

# tasks/main.yml: taps
brew tap homebrew/cask

# tasks/main.yml: formulas
brew install vim tmux zsh git wget ansible terraform awscli htop lua \
  lua-language-server reattach-to-user-namespace ripgrep telnet coreutils \
  mactop ruby cmake sqlite fd duckdb tig ffmpeg tree ncdu ollama fzf \
  gnu-sed gnu-tar virtualenv python@3.12 python@3.13 python@3.14 mas

# tasks/main.yml: casks
brew install --cask visual-studio-code sublime-text iterm2 google-chrome \
  zoom microsoft-teams claude-code antigravity-cli caffeine alfred iina \
  baidu-netdisk

# tasks/main.yml: Mac App Store apps (mas)
mas install 497799835   # Xcode
mas install 410395246   # Microsoft OneNote
mas install 836500024   # WeChat
mas install 1221250572  # Xnip

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
ln -sf ~/myconf/dotfiles/zsh/zshrc-mac.zsh ~/.zshrc
ln -sf ~/myconf/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/myconf/ssh ~/.ssh
ln -sf ~/myconf/config ~/.config
ln -sf ~/myconf/dotfiles/etc/tigrc ~/.tigrc
ln -sf ~/myconf/dotfiles/llm/claude ~/myconf/config/claude
ln -sf ~/myconf/dotfiles/llm/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/myconf/dotfiles/llm/claude/settings.json ~/.claude/settings.json
ln -sf ~/myconf/dotfiles/llm/claude/skills ~/.claude/skills
ln -sf ~/myconf/dotfiles/llm/openai ~/myconf/config/openai
ln -sf ~/myconf/dotfiles/llm/openai/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/myconf/dotfiles/etc/fd ~/myconf/config/fd
ln -sf ~/myconf/dotfiles/llm/openai/skills/ansible ~/.codex/skills/ansible
ln -sf ~/myconf/dotfiles/llm/openai/skills/grillme ~/.codex/skills/grillme
ln -sf ~/myconf/dotfiles/llm/openai/skills/terraform ~/.codex/skills/terraform
touch ~/.vimrc-env.vim ~/.vimrc-local.vim ~/.global.env
cp ~/myconf/dotfiles/etc/git/gitconfig-init.ini ~/.gitconfig

# tasks/iterm2.yml: live-sync prefs folder + font
defaults write com.googlecode.iterm2 PrefsCustomFolder -string ~/myconf/dotfiles/iterm2/prefs
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
curl -L -o ~/Library/Fonts/DroidSansMNerdFont-Regular.otf \
  https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
# then relaunch iTerm2 once to pull in the tracked prefs (or General > Preferences
# > "Save Settings to Folder Now" the other direction, to seed it initially)
