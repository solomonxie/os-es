# Reverse of `ansible-playbook site.yml`: pulls this machine's live app
# configs back into the repo, so a laptop's current state becomes what a new
# one is provisioned from. Run from repo root.

DOTFILES := $(CURDIR)
MACOS_MANUAL := $(DOTFILES)/ansible/manual/macos
VSCODE_USER := $(HOME)/Library/Application Support/Code/User
VSCODE_CLI := /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code

.PHONY: backup-mac backup-brew backup-mas backup-vscode backup-gitconfig backup-iterm2-profile

backup-mac: backup-brew backup-mas backup-vscode backup-gitconfig
	@echo "Done. iTerm2 prefs sync automatically on quit (ansible/roles/macos/iterm2/prefs)."
	@echo "Run 'make backup-iterm2-profile' separately to refresh the legacy Dynamic Profile JSON."

backup-brew:
	brew bundle dump --force --file="$(MACOS_MANUAL)/Brewfile"

backup-mas:
	mas list > "$(MACOS_MANUAL)/mas-apps.txt"

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
