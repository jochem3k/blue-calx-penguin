#!/bin/bash

set -ouex pipefail

# Run the shared customizations first:
source /ctx/common/build_files/build.sh
source /ctx/gnome/build_files/build.sh

# Copy this machine's system_files into the image
# (mounted at /ctx/system_files by the machine's Containerfile)
cp -avf "/ctx/system_files"/. /

### Thinkpad-specific customizations below ###

# thinkpad:
echo "blue-calx-penguin-thinkpad" > /usr/share/calx/image-name

# Packages can be installed from any enabled yum repo on the image.

dnf5 install -y \
brightnessctl \
playerctl

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5

#### Enable SystemD unit files

