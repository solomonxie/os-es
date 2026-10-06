.PHONY: install-mac backup-mac backup-brew backup-vscode backup-gitconfig backup-iterm2-profile

export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)

DOTFILES := $(CURDIR)
MACOS_MANUAL := $(DOTFILES)/ansible/roles/macos/manual
VSCODE_USER := $(HOME)/Library/Application Support/Code/User
VSCODE_CLI := /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
ANSIBLE_ARGS ?=


install-mac:
	@if ! command -v brew >/dev/null 2>&1; then \
		if [ -x /opt/homebrew/bin/brew ]; then \
			eval "$$(/opt/homebrew/bin/brew shellenv)"; \
		elif [ -x /usr/local/bin/brew ]; then \
			eval "$$(/usr/local/bin/brew shellenv)"; \
		else \
			echo "==> Homebrew not found. Installing Homebrew..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
			if [ -x /opt/homebrew/bin/brew ]; then \
				eval "$$(/opt/homebrew/bin/brew shellenv)"; \
			elif [ -x /usr/local/bin/brew ]; then \
				eval "$$(/usr/local/bin/brew shellenv)"; \
			fi; \
		fi; \
	fi; \
	if ! command -v ansible-playbook >/dev/null 2>&1; then \
		echo "==> Ansible not found. Installing via Homebrew..."; \
		brew install ansible; \
	fi; \
	mkdir -p "$(HOME)/myconf"; \
	if [ "$(DOTFILES)" != "$(HOME)/myconf/dotfiles" ] && [ ! -e "$(HOME)/myconf/dotfiles" ]; then \
		echo "==> Linking $(DOTFILES) to $(HOME)/myconf/dotfiles..."; \
		ln -s "$(DOTFILES)" "$(HOME)/myconf/dotfiles"; \
	fi; \
	if [ -d "$(HOME)/.ssh" ] && [ ! -L "$(HOME)/.ssh" ]; then \
		echo "==> Migrating existing ~/.ssh to ~/myconf/ssh..."; \
		mkdir -p "$(HOME)/myconf/ssh"; \
		cp -an "$(HOME)/.ssh/." "$(HOME)/myconf/ssh/"; \
		chmod 700 "$(HOME)/myconf/ssh"; \
		mv "$(HOME)/.ssh" "$(HOME)/.ssh.bak.$$(date +%Y%m%d%H%M%S)"; \
	fi; \
	mkdir -p "$(HOME)/myconf/ssh"; \
	chmod 700 "$(HOME)/myconf/ssh"; \
	if [ -d "$(HOME)/.config" ] && [ ! -L "$(HOME)/.config" ]; then \
		echo "==> Migrating existing ~/.config to ~/myconf/config..."; \
		mkdir -p "$(HOME)/myconf/config"; \
		cp -an "$(HOME)/.config/." "$(HOME)/myconf/config/"; \
		mv "$(HOME)/.config" "$(HOME)/.config.bak.$$(date +%Y%m%d%H%M%S)"; \
	fi; \
	mkdir -p "$(HOME)/myconf/config"; \
	echo "==> Running Ansible macOS setup..."; \
	cd "$(DOTFILES)/ansible" && ansible-playbook -i inventory.ini site.yml $(ANSIBLE_ARGS)



backup-mac: backup-brew backup-vscode backup-gitconfig
	@echo "Done. iTerm2 prefs sync automatically on quit (ansible/roles/macos/iterm2/prefs)."
	@echo "Run 'make backup-iterm2-profile' separately to refresh the legacy Dynamic Profile JSON."

backup-brew:
	brew bundle dump --force --file="$(MACOS_MANUAL)/Brewfile"

backup-vscode:
	mkdir -p "$(MACOS_MANUAL)/vscode"
	cp "$(VSCODE_USER)/settings.json" "$(MACOS_MANUAL)/vscode/settings.json"
	[ -f "$(VSCODE_USER)/keybindings.json" ] && \
		cp "$(VSCODE_USER)/keybindings.json" "$(MACOS_MANUAL)/vscode/keybindings.json" || true
	"$(VSCODE_CLI)" --list-extensions > "$(MACOS_MANUAL)/vscode/extensions.txt"

backup-gitconfig:
	cp "$(HOME)/.gitconfig" "$(DOTFILES)/etc/git/gitconfig-init.ini"

# iTerm2's full live plist already syncs automatically (loads/saves on quit,
# see ansible/roles/macos/iterm2/prefs/). This only refreshes the standalone
# Dynamic Profile JSON kept for manual/legacy use -- reshapes the plist's
# "New Bookmarks" array into iTerm2's {"Profiles": [...]} JSON schema.
backup-iterm2-profile:
	plutil -extract "New Bookmarks" xml1 -o /tmp/iterm2-profiles.plist \
		"$(DOTFILES)/ansible/roles/macos/iterm2/prefs/com.googlecode.iterm2.plist"
	plutil -convert json /tmp/iterm2-profiles.plist -o /tmp/iterm2-profiles.json
	python3 -c "import json; json.dump({'Profiles': json.load(open('/tmp/iterm2-profiles.json'))}, open('$(MACOS_MANUAL)/iterm2-profile.json', 'w'), indent=2)"
	rm -f /tmp/iterm2-profiles.plist /tmp/iterm2-profiles.json
