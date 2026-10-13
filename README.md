# os-es

Machine setup for macOS, Ubuntu, Alpine and Raspberry Pi, plus shared CLI configs (git, tig, fd, pylint).

- **macOS:** `install-shell-tools.sh` clones and installs [vim-for-speed](https://github.com/solomonxie/vim-for-speed), [shells-on-shells](https://github.com/solomonxie/shells-on-shells) and [tmux-ing](https://github.com/solomonxie/tmux-ing) with plain git, no Ansible; an Ansible role then installs Homebrew packages, Neovim, language runtimes and iTerm2 prefs.
- **Ubuntu, Alpine, Raspberry Pi:** reference scripts under `ansible/roles/<os>/manual/`.

## New Mac

```sh
curl -fsSL https://raw.githubusercontent.com/solomonxie/os-es/master/bootstrap.sh | bash
```

This installs the Command Line Tools, clones this repo to `~/.config/os-es`, runs `install-shell-tools.sh`, then `make install-mac`, which installs Homebrew and Ansible and runs the playbook. No `sudo`.

vim-for-speed and tmux-ing are cloned straight into `~/.config/nvim` and `~/.config/tmux`; shells-on-shells goes to `~/.config/shells-on-shells` and links `~/.config/zsh`, `~/.config/bash` and `~/.zshrc`. `install.sh` links the shared CLI configs: `~/.tigrc`, plus `fd`, `pylintrc` and git files under `~/.config`.

See [ansible/README.md](ansible/README.md) for what the role does. `ansible/roles/macos/manual/init_macos.sh` is the same setup as a plain shell script.
