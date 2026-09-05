# macOS Setup Automation

Ansible playbook that provisions a new Mac: Homebrew taps/formulas/casks,
Mac App Store apps, Neovim (installed from the GitHub release, not
Homebrew), Python/Node language environments, iTerm2's prefs, and the
dotfile symlinks into `$HOME`. `../manual_macos.sh` is the shell
equivalent, kept in sync by hand for whenever running Ansible itself
isn't an option.

iTerm2 is pointed at `iterm2/prefs/` in this repo (its own "load prefs
from a custom folder" feature) instead of a one-way Dynamic Profile, so
it reads *and writes* that folder — quitting iTerm2 saves whatever you
changed in the GUI back into the repo, ready to `git commit`.

## `manual/`

Reference scripts and configs that predate this Ansible role, or cover
machines/OSes it doesn't provision (Raspberry Pi, Ubuntu servers, AWS,
old Alpine/EC2 Makefiles). They used to be scattered across the repo root
as their own top-level folders (`makefiles/`, `os/`, `aws/`, `scripts/`,
`configure`, `init_mac.sh`, `clang/autotools-mac.sh`, `utils/install_ffmpeg.sh`)
and were consolidated here for one place to look for "how did I set this
up by hand before automation." Nothing in here is run by the playbook.
