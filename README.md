# macbook-arch-system

System-level (`/etc`, `/usr/local`) tweaks for running Arch Linux on a
**MacBook10,1** (12-inch 2017). These are hardware fixes, separate from the
user-level [hyprland-rice](https://github.com/juicecultus/hyprland-rice) dotfiles.

## Contents

### Touchpad palm rejection — `etc/libinput/local-overrides.quirks`
The `applespi` driver enumerates the Apple SPI clickpad as vendor `0x06CB`
(Synaptics), so libinput's built-in `[Apple Laptop Touchpad (SPI)]` quirk —
which requires `MatchVendor=0x05AC` — never matches, and **palm rejection stays
off**. The symptom: while typing, a palm/thumb brush registers as a tap and the
text caret jumps backward. Reproduces on GNOME, KDE, Cosmic and Hyprland alike
because the gap is in libinput, not the compositor.

This override matches the real device IDs and reapplies the upstream Apple SPI
tuning (size-based palm detection — the device exposes `MT_TOUCH_MAJOR` but no
pressure axis, so size-based is the only option). **Takes effect on next login.**

### Power-profile auto-switch — `power-profile-auto` + `.service` + udev rule
Sets `power-profiles-daemon` to **balanced** on AC, **power-saver** on battery,
re-evaluated whenever the AC adapter (`ADP1`) state changes.

### Instant battery refresh — `etc/udev/rules.d/99-waybar-battery.rules`
The waybar battery indicator is a custom module (see
[hyprland-rice](https://github.com/juicecultus/hyprland-rice)
`battery-status`) so it keeps its Font Awesome glyphs. On its own it only
repolls every 30s, so plug/unplug looks laggy. This rule fires on every
`power_supply` `change` uevent (AC adapter + battery) and pokes waybar with
`SIGRTMIN+8`, which the module listens for (`"signal": 8`) — the icon flips to
the charging bolt within ~10ms. Pure cosmetic glue between the two repos;
harmless if you don't run this rice.

### Ambient brightness — `usr/local/bin/auto-brightness`
Drives the backlight from the ambient light sensor via `acpi_call` (avoids
spurious OSD popups). Requires the `acpi_call` module.

## Install

```sh
git clone https://github.com/juicecultus/macbook-arch-system
cd macbook-arch-system
sudo ./install.sh
```

Verify after relogin that palm rejection is active (type with a palm resting on
the pad — the caret should no longer jump).
