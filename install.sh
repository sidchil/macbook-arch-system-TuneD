#!/usr/bin/env bash
# Install MacBook10,1 system-level tweaks. Requires root (writes to /etc, /usr/local).
set -euo pipefail
cd "$(dirname "$0")"
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }

install -Dm644 etc/libinput/local-overrides.quirks          /etc/libinput/local-overrides.quirks
install -Dm644 etc/systemd/system/power-profile-auto.service /etc/systemd/system/power-profile-auto.service
install -Dm644 etc/udev/rules.d/99-power-profile-auto.rules  /etc/udev/rules.d/99-power-profile-auto.rules
install -Dm644 etc/udev/rules.d/99-waybar-battery.rules      /etc/udev/rules.d/99-waybar-battery.rules
install -Dm755 usr/local/bin/power-profile-auto             /usr/local/bin/power-profile-auto
install -Dm755 usr/local/bin/auto-brightness               /usr/local/bin/auto-brightness

systemctl daemon-reload
systemctl enable --now power-profile-auto.service
udevadm control --reload

echo "Done. Touchpad palm rejection applies on next login (libinput re-init)."
