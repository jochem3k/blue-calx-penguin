#!/bin/bash

set -ouex pipefail

# Run the shared customizations first:
# - copies common system_files from /ctx/common/system_files to /
# - installs shared packages (tmux, etc.)
source /ctx/common/build_files/build.sh

### Desktop-specific customizations below ###

# Packages can be installed from any enabled yum repo on the image.

#### Enable SystemD unit files

systemctl enable var-mnt-data.mount
