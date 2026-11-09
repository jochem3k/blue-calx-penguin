#!/bin/bash

set -ouex pipefail

# Run the shared customizations first:
# - copies common system_files from /ctx/common/system_files to /
# - installs shared packages (tmux, etc.)
source /ctx/common/build_files/build.sh

### Desktop-specific customizations below ###

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images

# Example: install desktop-only packages here
# dnf5 install -y steam

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
