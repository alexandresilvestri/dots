#!/bin/sh
set -e
[ -d "$HOME/.local/share/omarchy" ] || exit 0
tmp=$(mktemp)
echo 'Defaults!/usr/bin/pacman env_keep += "OMARCHY_ALLOW_DIRECT_PACMAN"' > "$tmp"
sudo visudo -cf "$tmp"
sudo install -m 0440 "$tmp" /etc/sudoers.d/omarchy-pacman
rm "$tmp"
