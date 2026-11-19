# blue-calx-penguin

Custom Fedora Atomic bootc images for my machines.
Not a template or a general-purpose image; built for my hardware.

## Images
| Image | Machine | Base |
|---|---|---|
| blue-calx-penguin-desktop | Desktop (Nvidia, open kernel module) | silverblue-main + akmods-nvidia-open |
| blue-calx-penguin-thinkpad | ThinkPad (Maxwell GPU, nouveau driver) | silverblue-main |
| blue-calx-penguin-server | Proxmox based VM servers | ucore-minimal:stable |

## Install
`sudo bootc switch ghcr.io/jochem3k/blue-calx-penguin-<machine>:latest`
(from an existing bootc system, or via the ISO built by the Justfile)

## Build
`just build <image> <tag> images/<machine>/Containerfile`
Images are also built by GitHub Actions (workflow_dispatch).

## Initial Server Provisioning (CoreOS to uCore)
Host your Ignition file locally on port 8080 (run from the directory containing your .ign file)
`python3 -m http.server 8080`

Install bare-metal CoreOS with your Ignition config
`sudo coreos-installer install /dev/sda --insecure-ignition --ignition-url [http://192.168.2.193:8080/](http://192.168.2.193:8080/)<IGNITION_FILE>.ign`

Switch directly to your custom server image
`sudo bootc switch ghcr.io/jochem3k/blue-calx-penguin-server:latest`

Reboot to apply the new image
`sudo systemctl reboot`

## Structure
images/common/    shared across all machines
images/gnome/     GNOME desktop layer
images/<machine>/ per-machine packages, files, kargs
images/server/    atomic server

## Verification
Images are signed with cosign; see cosign.pub.
