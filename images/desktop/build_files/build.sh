#!/bin/bash

set -ouex pipefail

# Copy this machine's system_files into the image
# (mounted at /ctx/system_files by the machine's Containerfile)
cp -avf "/ctx/system_files"/. /

# Run the shared customizations first:
source /ctx/common/build_files/build.sh
source /ctx/gnome/build_files/build.sh

### Desktop-specific customizations below ###

# desktop:
echo "cerulean-city-customs-desktop" > /usr/share/cerulean/image-name

# Packages can be installed from any enabled yum repo on the image.


#### Enable SystemD unit files

systemctl enable var-mnt-data.mount
