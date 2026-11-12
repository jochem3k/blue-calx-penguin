# blue-calx-penguin

Custom Fedora Silverblue-based bootc images for my machines.
Not a template or a general-purpose image; built for my hardware.

## Images
| Image | Machine | Base |
|---|---|---|
| blue-calx-penguin-desktop | Desktop (Nvidia, open kernel module) | fedora-silverblue-nvidia-open |
| blue-calx-penguin-thinkpad | ThinkPad (Maxwell GPU, proprietary driver) | fedora-silverblue-nvidia |

## Install
`sudo bootc switch ghcr.io/jochem3k/blue-calx-penguin-<machine>:latest`
(from an existing bootc system, or via the ISO built by the Justfile)

## Build
`just build <image> <tag> images/<machine>/Containerfile`
Images are also built by GitHub Actions (workflow_dispatch).

## Structure
images/common/    shared across all machines
images/gnome/     GNOME desktop layer
images/<machine>/ per-machine packages, files, kargs

## Verification
Images are signed with cosign; see cosign.pub.
