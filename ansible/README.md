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
  profile, Makefile-macos/-font/-ruby/-lua...); app configs this Mac still
  uses by hand rather than via the role (lazygit.yml, pacman.sh,
  visidatarc.py, ranger/, python/ jupyter+debugger configs); and the
  install_{nvim,python,tmux,vim,zsh}.sh scripts, even though their own
  "Enviroment:" header still lists Ubuntu/Raspbian too — this Mac is the
  one that actually runs them by hand.
- `roles/ubuntu/manual/` and `roles/raspberrypi/manual/` — no tasks yet,
  reference only. `ubuntu/` is the default bucket for anything ambiguous
  that isn't Raspberry-Pi-specific and isn't one of the install_*.sh
  scripts above (apt/rpm, install_docker.sh, etc.). Each has its own
  `mini/` — stripped-down zsh/vim/tmux/git configs (no plugin manager, no
  LLM/dev tooling assumptions) for that kind of remote machine, not this
  Mac; deliberately duplicated between the two rather than shared, and
  also still *copied* at `manual/mini/` so the Makefile/script references
  pointing at the old path resolve.
- `roles/alpine/manual/` — Alpine-only (apk.sh). No tasks/vars yet either.
- `manual/makefiles/` — Makefiles that span more than one of the roles
  above (mac+ubuntu+raspbian targets in one file) or don't fit any of
  them (Makefile-alpine-os); everything with a single clear OS moved into
  that role's `manual/` instead.

`etc/` at the repo root only holds what's actually symlinked into the
current macOS setup (fd, git, pylintrc, tigrc); anything that fell out of
use there (ranger, ipython, jupyter/pip, efs_nginx.conf, samba) moved into
the relevant role's `manual/` above.
