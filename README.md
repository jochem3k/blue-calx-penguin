# cerulean-city-customs

Custom Fedora Silverblue-based bootc images for my machines.
Not a template or a general-purpose image; built for my hardware.

## Images
   Image | Machine | Base |
 |---|---|---|
 | cerulean-city-customs-desktop | Desktop (Nvidia, open kernel module) | fedora-silverblue-nvidia-open |
 | cerulean-city-customs-thinkpad | ThinkPad (Maxwell GPU, proprietary driver) | fedora-silverblue-nvidia |

## What's in it
- GNOME with curated extensions (Caffeine, Tiling Shell, ...)
- Shared package set: fish, ghostty, netbird, helium, CLI tools (eza, bat, fzf, ...)
- System Flatpaks provisioned on first boot from flatpaks-*.list
- Automatic updates via uupd (staged by rpm-ostree)
- Terra repo for extra packages

## Install
bootc switch to ghcr.io/jochem3k/cerulean-city-customs-<machine>:latest
(from an existing bootc system, or via the ISO built by the Justfile)

## Build
just build <image> <tag> images/<machine>/Containerfile
Images are also built by GitHub Actions (workflow_dispatch).

## Structure
images/common/    shared across all machines
images/gnome/     GNOME desktop layer
images/<machine>/ per-machine packages, files, kargs

## Verification
Images are signed with cosign; see cosign.pub.
