#!/bin/bash

set -ouex pipefail

# Copy the GNOME system_files into the image
# (mounted at /ctx/gnome/ by the machine's Containerfile)
cp -avf "/ctx/gnome/system_files"/. /

### Install packages (shared across all Gnome machines)

# Install DNF packages
dnf5 install -y \
xdg-terminal-exec \
gnome-tweaks \
gnome-shell-extension-gsconnect \
sushi

# Remove DNF packages
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
rm -rf /var/cache/dnf5 /var/cache/libdnf5

# Run Bluebuild Flatpak module
/tmp/scripts/run_module.sh 'default-flatpaks' '{
  "type": "default-flatpaks",
  "configurations": [
    {
      "notify": false,
      "scope": "system",
      "install": [
        "io.github.celluloid_player.Celluloid",
        "com.mattjakeman.ExtensionManager",
        "page.tesk.Refine",
        "org.gnome.Calendar",
        "org.gnome.Epiphany",
        "org.gnome.Maps"
      ]
    }
  ]
}'

### Bluebuild Gnome extensions module ("Caffeine","Just Perfection","Clipboard Indicator","AppIndicator and KStatusNotifierItem Support","Tiling Shell","Quick Close in Overview").

/tmp/scripts/run_module.sh 'gnome-extensions' \
  '{"type":"gnome-extensions","install":["517","3843","779","615","7065","352"]}'

### Compile glib schemas (picks up any *.gschema.override)

glib-compile-schemas /usr/share/glib-2.0/schemas/
dconf update

#### Enable SystemD unit files

systemctl enable gdm.service
