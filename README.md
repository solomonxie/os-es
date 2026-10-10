# os-es

Machine setup for macOS, Ubuntu, Alpine and Raspberry Pi, plus shared CLI configs (git, tig, fd, pylint).

- **macOS:** an Ansible role installs Homebrew packages, Neovim, language runtimes and iTerm2 prefs, then clones and installs [svimmer](https://github.com/solomonxie/svimmer), [coastal-shells](https://github.com/solomonxie/coastal-shells), [tmuxedo](https://github.com/solomonxie/tmuxedo) and [llm-collections](https://github.com/solomonxie/llm-collections).
- **Ubuntu, Alpine, Raspberry Pi:** reference scripts under `ansible/roles/<os>/manual/`.

## New Mac

```sh
curl -fsSL https://raw.githubusercontent.com/solomonxie/os-es/master/bootstrap.sh | bash
```

This installs the Command Line Tools, clones this repo to `~/.config/os-es`, then runs `make install-mac`, which installs Homebrew and Ansible and runs the playbook. No `sudo`.

The other repos are cloned straight into their tool's config dir: `~/.config/nvim`, `~/.config/zsh`, `~/.config/tmux`, `~/.config/llm-collections`. `install.sh` links the shared CLI configs: `~/.tigrc`, plus `fd`, `pylintrc` and git files under `~/.config`.

See [ansible/README.md](ansible/README.md) for what the role does. `ansible/roles/macos/manual/init_macos.sh` is the same setup as a plain shell script.
