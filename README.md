# ubuntu-cloud-init

This repo outlines the steps I follow to create a new Ubuntu cloud image template in Proxmox.

1. Download an Ubuntu image from [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/) and upload it to the Proxmox server
2. Download the `cloud-user-config` file from this repo
3. Run the `create-proxmox-vm.sh` script to create a new VM template in Proxmox

# Credits

These steps are an amalgamation of the steps found in the following repos:

- https://github.com/JamesTurland/JimsGarage/tree/main/Kubernetes/Cloud-Init
- https://github.com/chris2k20/proxmox-cloud-init
