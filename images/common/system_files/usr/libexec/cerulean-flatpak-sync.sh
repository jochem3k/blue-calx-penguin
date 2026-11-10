#!/bin/bash
set -euo pipefail

MANIFEST_DIR="/usr/share/cerulean"

# Ensure Flathub exists
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true

# 1. Install any missing Flatpaks listed in the image manifests
# (handles any *.list in the dir; skips missing files gracefully)
for LIST in "${MANIFEST_DIR}"/*.list; do
    [[ -f "${LIST}" ]] || continue   # no matches → glob stays literal, just skip

    while read -r app; do
        [[ -z "${app}" || "${app}" =~ ^# ]] && continue
        flatpak --system install -y -q --noninteractive flathub "${app}" >/dev/null 2>&1 || true
    done < "${LIST}"
done

# 2. Update all installed system Flatpaks
flatpak --system update -y -q --noninteractive >/dev/null 2>&1 || true
