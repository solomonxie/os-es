# macOS Setup Automation

Ansible playbook that provisions a new Mac: Homebrew taps/formulas/casks,
Mac App Store apps, Neovim (installed from the GitHub release, not
Homebrew), Python/Node language environments, iTerm2's prefs, and the
dotfile symlinks into `$HOME`. `../manual_macos.sh` is the shell
equivalent, kept in sync by hand for whenever running Ansible itself
isn't an option.

iTerm2 is pointed at `roles/macos/iterm2/prefs/` in this repo (its own "load prefs
from a custom folder" feature) instead of a one-way Dynamic Profile, so
it reads *and writes* that folder — quitting iTerm2 saves whatever you
changed in the GUI back into the repo, ready to `git commit`.

## `manual/`

Reference scripts and configs that predate automation, or cover
machines/OSes no role provisions yet. Nothing in here is run by the
playbook. Split by which role they belong to, so it's clear at a glance
what each applies to:

- `roles/macos/manual/` — mac-only reference scripts/configs
  (homebrew.sh, init_mac.sh, clang_autotools_mac.sh, key remapping, iTerm2
  profile...), plus app configs this Mac still uses by hand rather than
  via the role (lazygit.yml, pacman.sh, visidatarc.py).
- `roles/ubuntu-or-raspberrypi/manual/` — no tasks yet, reference only.
  Split further into `ubuntu/` (Ubuntu-only, plus every script spanning
  multiple Linux-ish OSes that isn't Raspberry-Pi-specific — apt/apk/rpm,
  install_vim.sh, install_docker.sh, etc.), `raspberrypi/` (Raspbian-only),
  and `mini/` — stripped-down zsh/vim/tmux/git configs (no plugin manager,
  no LLM/dev tooling assumptions) for remote servers or a Pi, not this
  Mac. `mini/` is *copied* here (and kept at `manual/mini/` too) so the
  Makefile/script references pointing at the old path still resolve.
- `manual/makefiles/` — old per-tool Makefiles, not tied to one role.

`etc/` at the repo root only holds what's actually symlinked into the
current macOS setup (fd, git, pylintrc, tigrc); anything that fell out of
use there (ranger, ipython, jupyter/pip, efs_nginx.conf, samba) moved into
the relevant role's `manual/` above.
