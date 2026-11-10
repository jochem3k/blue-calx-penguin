#!/bin/bash

set -ouex pipefail

# Copy the GNOME system_files into the image
# (mounted at /ctx/common/ by the machine's Containerfile)
cp -avf "/ctx/gnome/system_files"/. /

### Install packages (shared across all gnome machines)

# Packages can be installed from any enabled yum repo on the image.


dnf5 install -y \
xdg-terminal-exec \
gnome-tweaks \
gnome-shell-extension-gsconnect \
sushi

dnf5 remove -y \
gnome-tour \
yelp \
gnome-user-docs \
gnome-classic-session \
gnome-shell-extension-apps-menu \
gnome-shell-extension-background-logo \
gnome-shell-extension-launch-new-instance \
gnome-shell-extension-places-menu \
gnome-shell-extension-window-list

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5 /tmp/*


#### Enable SystemD unit files

systemctl enable gdm.service
