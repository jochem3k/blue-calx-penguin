#!/bin/bash
set -euo pipefail

MANIFEST_DIR="/usr/share/calx"

# Ensure Flathub exists
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo </dev/null

# 1. Install any missing Flatpaks listed in the image manifests
for LIST in "${MANIFEST_DIR}"/*.list; do
    [[ -f "${LIST}" ]] || continue

    while IFS= read -r app || [[ -n "${app}" ]]; do
        [[ -z "${app}" || "${app}" =~ ^# ]] && continue
        if ! flatpak --system info "${app}" >/dev/null 2>&1 </dev/null; then
            flatpak --system install -y --noninteractive flathub "${app}" </dev/null || true
        fi
    done < "${LIST}"
done

# 2. Update all installed system Flatpaks
flatpak --system update -y --noninteractive </dev/null || true
