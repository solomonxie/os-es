#!make
-include envfile
-include envfile-local

DOTFILES ?= ~/myconf/dotfiles
MYOS ?= `cat /tmp/env-os`
USER ?= `cat /tmp/env-user`

install-homebrew:
	command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew tap Homebrew/bundle


install-softwares: install-homebrew
	brew bundle install --file ./Brewfile
	brew bundle dump --file=./Brewfile


homebrew-change-source:
	# brew.git:
	cd "$(brew --repo)"
	git remote set-url origin https://github.com/Homebrew/brew.git
	# homebrew-core.git:
	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://github.com/Homebrew/homebrew-core.git
	# # Change Back
	# brew.git:
	# cd "$(brew --repo)"
	# git remote set-url origin https://github.com/Homebrew/brew.git
	# # homebrew-core.git:
	# cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	# git remote set-url origin https://github.com/Homebrew/homebrew-core.git
