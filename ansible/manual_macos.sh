#!/usr/bin/env bash
# Manual equivalent of ansible/roles/macos -- for reference, not execution.

# tasks/main.yml: Homebrew taps, formulas, casks
brew tap homebrew/cask
brew install vim tmux zsh git wget ansible terraform awscli mas ripgrep fzf ...
brew install --cask visual-studio-code sublime-text iterm2 google-chrome zoom

# tasks/main.yml: Mac App Store apps (must be signed into the App Store first)
mas install 497799835   # Xcode
mas install 410395246   # Microsoft OneNote
mas install 836500024   # WeChat
mas install 1221250572  # Xnip

# tasks/languages.yml: Python/Node virtual environments
pip install virtualenv nodeenv
virtualenv -p python3.14 ~/virtualenv/venv
nodeenv ~/virtualnode/venv
~/virtualenv/venv/bin/pip install -r ~/myconf/dotfiles/ansible/roles/macos/tasks/requirements_py.txt

# tasks/neovim.yml: Neovim from the GitHub release (not Homebrew)
curl -Lo /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-macos-arm64.tar.gz
tar -xzf /tmp/nvim.tar.gz -C /tmp
mv /tmp/nvim-macos-arm64 ~/nvim-macos-0.11.2
xattr -r -d com.apple.quarantine ~/nvim-macos-0.11.2

# tasks/shell_tools.yml: dotfile symlinks
ln -sf ~/myconf/dotfiles/zsh/zshrc-mac.zsh ~/.zshrc
ln -sf ~/myconf/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/myconf/ssh ~/.ssh
ln -sf ~/myconf/config ~/.config
ln -sf ~/myconf/dotfiles/ai/claude/skills ~/.claude/skills
touch ~/.vimrc-env.vim ~/.vimrc-local.vim ~/.global.env
cp ~/myconf/dotfiles/etc/git/gitconfig-init.ini ~/.gitconfig

# tasks/iterm2.yml: profile + Nerd Font
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
ln -sf ~/myconf/dotfiles/os/macos/iterm2-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/iterm2-profile.json
curl -Lo ~/Library/Fonts/DroidSansMNerdFont-Regular.otf https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
