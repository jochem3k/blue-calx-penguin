#!/bin/bash

set -ouex pipefail

# Run the shared customizations first:
# - copies common system_files from /ctx/common/system_files to /
# - installs shared packages (tmux, etc.)
source /ctx/common/build_files/build.sh

### Thinkpad-specific customizations below ###

dnf5 install -y \
brightnessctl \
playerctl

# Packages can be installed from any enabled yum repo on the image.

#### Enable SystemD unit files
