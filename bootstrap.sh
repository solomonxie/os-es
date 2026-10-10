#!/usr/bin/env bash
# Fresh Mac, one line: curl -fsSL https://raw.githubusercontent.com/solomonxie/os-es/master/bootstrap.sh | bash
set -euo pipefail
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Re-run this once the Command Line Tools finish installing."
  exit 1
fi
mkdir -p ~/myconf
[ -d ~/myconf/os-es ] || git clone https://github.com/solomonxie/os-es.git ~/myconf/os-es
make -C ~/myconf/os-es install-mac
