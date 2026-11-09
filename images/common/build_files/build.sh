#!/bin/bash

set -ouex pipefail

# Copy the COMMON system_files into the image
# (mounted at /ctx/common/ by the machine's Containerfile)
cp -avf "/ctx/common/system_files"/. /

### Install packages (shared across all machines)

# Packages can be installed from any enabled yum repo on the image.

dnf5 -y copr enable jsbillings/netbird
dnf5 -y copr enable imput/helium

dnf5 install -y \
firewall-config \
fish \
fprintd-pam \
git-credential-libsecret \
gh \
ghostty \
kitty \
google-croscore-arimo-fonts \
google-croscore-tinos-fonts \
google-croscore-cousine-fonts \
google-crosextra-carlito-fonts \
google-crosextra-caladea-fonts \
helium-bin \
netbird-client \
netbird-ui \
p7zip \
p7zip-plugins \
sshfs \
steam-devices \
system-config-printer \
ublue-os-just \
unrar \
uupd \
fzf \
ripgrep \
eza \
bat \
zoxide \
btop \
duf \
dust \
fresh \
iperf3 \
fastfetch

# Cleanup DNF metadata

dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5 /tmp/*


#### Enable SystemD unit files

systemctl enable podman.socket
systemctl enable netbird.service
systemctl enable uupd.timer
systemctl enable cups.service
systemctl mask NetworkManager-wait-online.service
systemctl --global enable netbirdui.service
