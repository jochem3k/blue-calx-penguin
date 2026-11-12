#!/bin/bash

set -ouex pipefail

# Copy the COMMON system_files into the image
# (mounted at /ctx/common/ by the machine's Containerfile)
cp -avf "/ctx/common/system_files"/. /

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

# Packages can be installed from any enabled yum repo on the image.

dnf5 -y copr enable jsbillings/netbird
dnf5 -y copr enable imput/helium
dnf5 -y copr enable ublue-os/packages
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys

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
ublue-os-just \
unrar \
uupd \
zoxide

dnf5 remove -y \
firefox \
firefox-langpacks

dnf5 -y copr disable jsbillings/netbird
dnf5 -y copr disable imput/helium
dnf5 -y copr disable ublue-os/packages

# Update font cache
fc-cache -f /usr/share/fonts

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5

# Flatpak list enable
chmod +x /usr/libexec/calx-flatpak-sync.sh
systemctl enable calx-flatpak-sync.service


#### Enable SystemD unit files

systemctl enable podman.socket
systemctl enable netbird.service
systemctl enable uupd.timer
systemctl enable cups.service
systemctl mask NetworkManager-wait-online.service
systemctl --global enable netbirdui.service
