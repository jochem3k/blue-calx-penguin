#!/bin/bash
set -euo pipefail

flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

grep -hvE '^\s*(#|$)' /usr/share/calx/*.list | xargs -r flatpak --system install -y --noninteractive flathub
