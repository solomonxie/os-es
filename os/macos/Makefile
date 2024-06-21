#!make
-include envfile
-include envfile-local

DOTFILES ?= ~/myconf/dotfiles
MYOS ?= `cat /tmp/env-os`
USER ?= `cat /tmp/env-user`

install-brew:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update


install-software: install-brew
	brew bundle
	brew bundle install --file $(DOTFILES)/pacman/Brewfile


change_source_brew:
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
