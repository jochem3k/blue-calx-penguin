#!/bin/bash

set -ouex pipefail

# Bluebuild Gnome extensions module mounts
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=ghcr.io/blue-build/modules:latest,src=/modules,dst=/tmp/modules,rw \
    --mount=type=bind,from=ghcr.io/blue-build/cli/build-scripts:latest,src=/scripts/,dst=/tmp/scripts/ \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh

# Run the shared customizations first:
source /ctx/common/build_files/build.sh
source /ctx/gnome/build_files/build.sh

### Thinkpad-specific customizations below ###

# Packages can be installed from any enabled yum repo on the image.

dnf5 install -y \
brightnessctl \
playerctl

#### Enable SystemD unit files
