#!/bin/bash
set -euo pipefail

LIST="/usr/share/cerulean/flatpaks.list"

# Exit cleanly if the manifest doesn't exist
[[ ! -f "${LIST}" ]] && exit 0

# Ensure Flathub exists
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true

# 1. Install any missing Flatpaks listed in the image
while read -r app; do
    [[ -z "${app}" || "${app}" =~ ^# ]] && continue
    flatpak --system install -y -q --noninteractive flathub "${app}" >/dev/null 2>&1 || true
done < "${LIST}"

# 2. Update all installed system Flatpaks
flatpak --system update -y -q --noninteractive >/dev/null 2>&1 || true
