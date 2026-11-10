#!/bin/bash

set -ouex pipefail

# Run the shared customizations first:
source /ctx/common/build_files/build.sh
source /ctx/gnome/build_files/build.sh

### Thinkpad-specific customizations below ###

# Packages can be installed from any enabled yum repo on the image.

dnf5 install -y \
brightnessctl \
playerctl

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5

#### Enable SystemD unit files
