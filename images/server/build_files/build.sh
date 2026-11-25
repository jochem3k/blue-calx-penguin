#!/bin/bash

set -ouex pipefail

### Fix /opt symlink for build-time RPM installs
## Fedora bootc symlinks /opt -> /var/opt, which is dangling in the build
## container and breaks RPMs that install into /opt (e.g. helium-bin).
## Replace it with a real directory for the build; bootc re-establishes
## the /var linkage on the deployed system.
rm -f /opt && mkdir -p /opt


### Install packages (shared across all servers)

# Add repositories
dnf5 -y copr enable jsbillings/netbird
dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable atim/lazydocker
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys

# Install DNF packages
dnf5 install -y \
bind-utils \
btop \
cifs-utils \
gh \
intel-gpu-tools \
iperf3 \
lazydocker \
fresh \
netbird-client \
nfs-utils \
rsync \
uupd

# Remove repositories
dnf5 -y copr disable jsbillings/netbird
dnf5 -y copr disable ublue-os/packages
dnf5 -y copr disable atim/lazydocker
dnf5 config-manager setopt 'terra*.enabled=0'

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5


### Copy the SERVER system_files into the image
### (mounted at /ctx/common/ by the servers's Containerfile)

cp -avf "/ctx/system_files"/. /

#### Enable SystemD unit files

systemctl enable netbird.service
systemctl enable uupd.timer
systemctl enable docker.service
systemctl enable docker.socket
systemctl enable docker-prune.timer
systemctl enable fix-qemuga-selinux.service
systemctl disable fwupd-refresh.timer
systemctl mask fwupd-refresh.service
