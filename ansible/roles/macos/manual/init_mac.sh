#! /usr/bin/env bash

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install gnu-sed gnu-tar gnupg coreutils findutils git make tree wget curl tig
brew install ag rg fd jq
brew install duckdb visidata

# Key repeats:
sudo defaults write -g ApplePressAndHoldEnabled -bool false
sudo defaults write -g InitialKeyRepeat -int 10
sudo defaults write -g KeyRepeat -int 1

# iTerm2
curl -L -o ~/Library/Fonts/DroidSansMNerdFont-Regular.otf \
  https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
cp os/macos/iterm2-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/

# SSH
ls ~/.ssh/id_rsa || ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa


# Dotfiles
for pair in os-es:os-es svimmer:nvim coastal-shells:zsh tmuxedo:tmux llm-collections:llm-collections; do
  repo=${pair%%:*} dest=~/.config/${pair#*:}
  [ -d $dest ] || git clone https://github.com/solomonxie/$repo.git $dest
  $dest/install.sh
done

# Git
read -p "Enter github user display name: " git_name
read -p "Enter github email: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Zsh
brew install zsh
source ~/.zshrc


# Python
brew install python3 virtualenv
ls ~/virtualenv/venv || virtualenv -p python3 ~/virtualenv/venv
source ~/.zshrc

# NodeJS
pip install nodeenv
ls ~/virtualenode/venv || nodeenv ~/virtualenode/venv
source ~/.zshrc


# Neovim
brew install vim ctag
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-macos.tar.gz
tar xvzf nvim-macos.tar.gz
mv nvim-macos ~/nvim-macos
sudo xattr -rd com.apple.quarantine ~/nvim-macos  # trust nvim runtime
pip install pynvim neovim python-lsp-server[all] pycodestyle python-language-server pyright pylint flake8==3.9.2
npm install -g neovim vim-language-server typescript typescript-language-server bash-language-server
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
ls ~/.local/share/nvim/site/autoload/plug.vim

# Tmux
echo "----------[  Installing Tmux   ]--------------"
brew install tmux reattach-to-user-namespace
export TMUX_PLUGIN_MANAGER_PATH='~/.tmux/plugins'
mv ~/.tmux/plugins ~/.tmux/plugins`date +%F` ||cat
mkdir -p ~/.tmux/plugins ||cat
ls ~/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
mkdir -p ~/.tmux/resurrect/ ||cat
