#!/bin/bash

set -ouex pipefail

### Expose mounted BlueBuild module path
export MODULE_DIRECTORY="/tmp/modules"

### Fix /opt symlink for build-time RPM installs
## Fedora bootc symlinks /opt -> /var/opt, which is dangling in the build
## container and breaks RPMs that install into /opt (e.g. helium-bin).
## Replace it with a real directory for the build; bootc re-establishes
## the /var linkage on the deployed system.
rm -f /opt && mkdir -p /opt

### Stamp image metadata for unprivileged consumers (fastfetch)
mkdir -p /usr/share/calx
date -u +'%Y-%m-%dT%H:%M:%SZ' > /usr/share/calx/build-timestamp

### Install packages (shared across all machines)

# Add repositories
dnf5 -y copr enable jsbillings/netbird
dnf5 -y copr enable imput/helium
dnf5 -y copr enable ublue-os/packages
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys

# Install DNF packages
dnf5 install -y \
adwaita-mono-fonts \
bat \
btop \
chezmoi \
duf \
dust \
eza \
fastfetch \
firewall-config \
fish \
fprintd-pam \
fresh \
fzf \
gh \
ghostty \
git-credential-libsecret \
google-croscore-arimo-fonts \
google-croscore-cousine-fonts \
google-croscore-tinos-fonts \
google-crosextra-caladea-fonts \
google-crosextra-carlito-fonts \
helium-bin \
iperf3 \
jetbrains-mono-fonts \
kitty \
netbird-client \
netbird-ui \
nerdfontssymbolsonly-nerd-fonts \
p7zip \
p7zip-plugins \
ripgrep \
sshfs \
steam-devices \
system-config-printer \
unrar \
uupd \
zoxide

# Remove DNF packages
dnf5 remove -y \
firefox \
firefox-langpacks

# Remove repositories
dnf5 -y copr disable jsbillings/netbird
dnf5 -y copr disable imput/helium
dnf5 -y copr disable ublue-os/packages

# Update font cache
fc-cache -f /usr/share/fonts

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5

# Run Bluebuild Flatpak module
/tmp/scripts/run_module.sh 'default-flatpaks' '{
  "type": "default-flatpaks",
  "configurations": [
    {
      "notify": true,
      "scope": "system",
      "repo": {
        "url": "https://dl.flathub.org/repo/flathub.flatpakrepo",
        "name": "flathub",
        "title": "Flathub (system)"
      },
      "install": [
        "io.github.Foldex.AdwSteamGtk",
        "com.bitwarden.desktop",
        "com.rafaelmardojai.Blanket",
        "hu.irl.cameractrls",
        "com.github.finefindus.eyedropper",
        "org.filezillaproject.Filezilla",
        "com.github.tchx84.Flatseal",
        "org.gimp.GIMP",
        "io.gitlab.adhami3310.Impression",
        "org.libreoffice.LibreOffice",
        "com.mojang.Minecraft",
        "md.obsidian.Obsidian",
        "com.vysp3r.ProtonPlus",
        "net.nokyan.Resources",
        "com.rustdesk.RustDesk",
        "com.spotify.Client",
        "com.valvesoftware.Steam",
        "io.github.flattool.Warehouse",
        "dev.zed.Zed",
        "app.zen_browser.zen",
        "io.github.kolunmi.Bazaar",
        "org.mozilla.firefox",
        "com.usebottles.bottles",
        "com.discordapp.Discord"
      ]
    }
  ]
}'

### Copy the COMMON system_files into the image
### (mounted at /ctx/common/ by the machine's Containerfile)

cp -avf "/ctx/common/system_files"/. /

#### Enable SystemD unit files

systemctl enable podman.socket
systemctl enable netbird.service
systemctl enable cups.service
systemctl enable uupd.timer
systemctl mask NetworkManager-wait-online.service
systemctl --global enable netbirdui.service
