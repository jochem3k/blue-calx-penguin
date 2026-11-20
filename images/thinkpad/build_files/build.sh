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

# Install DNF packages
dnf5 install -y \
brightnessctl \
playerctl

# Add repositories
dnf5 -y copr enable bieszczaders/kernel-cachyos

# Remove default kernel
dnf5 remove -y kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

# Install CachyOS kernel
dnf5 install -y kernel-cachyos

# Remove repositories
dnf5 -y copr disable bieszczaders/kernel-cachyos

# Cleanup DNF metadata
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/libdnf5

#### Enable SystemD unit files


#### Rebuild initramfs because of cachyos kernel
#
KERNEL_VERSION="$(rpm -q --queryformat='%{VERSION}-%{RELEASE}.%{ARCH}' kernel-cachyos)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --add ostree \
    -f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
