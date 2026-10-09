#!/usr/bin/env bash
# Enable SSH on this Mac for the LAN. Touches only sshd: no LaunchDaemons, pf, pmset or service disables
# (those broke GUI login once). Usage: bash init_ssh.sh [apply|verify|add-key "<pubkey>"]
set -euo pipefail

LAN_V6="fe80::/10"
DROPIN=/etc/ssh/sshd_config.d/000-lan.conf

ask() { # var prompt default
  local v; read -r -p "$2 [$3]: " v; printf -v "$1" '%s' "${v:-$3}"
}

apply() {
  local auth="PasswordAuthentication yes"
  [[ -s ~/.ssh/authorized_keys ]] && auth="PasswordAuthentication no
KbdInteractiveAuthentication no"
  sudo tee "$DROPIN" >/dev/null <<CONF
$auth
PermitRootLogin no
AllowUsers $(id -un)
X11Forwarding no
MaxAuthTries 3
CONF
  sudo sshd -t
  sudo launchctl enable system/com.openssh.sshd
  sudo launchctl print system/com.openssh.sshd >/dev/null 2>&1 \
    || sudo launchctl bootstrap system /System/Library/LaunchDaemons/ssh.plist
  echo "done: ssh $(id -un)@$(ipconfig getifaddr en0 || echo '<ip>')"
}

add_key() { # pins the key to the LAN, shell + Screen Sharing tunnel only
  local key=${1:?usage: add-key "ssh-ed25519 AAAA... name"}
  ask LAN_CIDRS "LAN CIDR(s) this key may connect from (e.g. 192.168.4.0/22)" "192.168.1.0/24"
  mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
  echo "from=\"${LAN_CIDRS// /,},$LAN_V6\",no-agent-forwarding,no-X11-forwarding,permitopen=\"localhost:5900\" $key" >> ~/.ssh/authorized_keys
}

verify() {
  local fail=0
  check() { if bash -c "$2" >/dev/null 2>&1; then echo "ok    $1"; else echo "FAIL  $1"; fail=1; fi; }
  check "ssh: listening on 22"       "nc -z -G2 127.0.0.1 22"
  check "ssh: root login off"        "sudo sshd -T | grep -qx 'permitrootlogin no'"
  check "ssh: keys pinned by from="  "! grep -vE '^(#|\$|from=)' ~/.ssh/authorized_keys"
  check "no custom LaunchDaemons"    "! ls /Library/LaunchDaemons | grep -q '^local\.'"
  check "pmset: SleepDisabled off"   "! pmset -g | grep -qE 'SleepDisabled[[:space:]]+1'"
  return $fail
}

case "${1:-apply}" in
  apply) apply ;;
  verify) verify ;;
  add-key) add_key "${2:-}" ;;
  *) echo "usage: $0 [apply|verify|add-key \"<pubkey>\"]"; exit 1 ;;
esac
