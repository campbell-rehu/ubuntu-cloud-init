# ubuntu-cloud-init

This repo outlines the steps I follow to create a new Ubuntu cloud image template in Proxmox.

1. Download an Ubuntu image from [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/). (I am using https://cloud-images.ubuntu.com/lunar/current/lunar-server-cloudimg-amd64-disk-kvm.img) using the Proxmox GUI
2. Create the VM in the Proxmox CLI

```bash
qm create 5000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
qm importdisk 5000 /var/lib/vz/template/iso/lunar-server-cloudimg-amd64-disk-kvm.img [STORAGE_NAME]
qm set 5000 --scsihw virtio-scsi-pci --scsi0 [STORAGE_NAME]:vm-5000-disk-0
qm set 5000 --ide2 [STORAGE_NAME]:cloudinit
qm set 5000 --boot c --bootdisk scsi0
qm set 5000 --serial0 socket --vga serial0
qm set 5000 --ipconfig0 "ip=dhcp"
qm set 5000 --agent enabled=1,fstrim_cloned_disks=1
qm resize 5000 scsi0 +10G
```

3. Setup the custom user config to pre-install the `qemu-guest-agent` apt package when a new VM template clone is initialised

```bash
# create a snippets directory in the /var/lib/vz directory
mkdir /var/lib/vz/snippets/
cd /var/lib/vz/snippets

# download the ubuntu-cloud-user-config.yaml
curl -O https://raw.githubusercontent.com/campbell-rehu/ubuntu-cloud-init/main/ubuntu-cloud-user-config.yaml

# edit the user, password and ssh_authorized_keys fields in the downloaded file
vim ubuntu-cloud-user-config.yaml

# set the custom config on the VM created above
qm set 5000 --cicustom "user=local:snippets/ubuntu-cloud-user-config.yaml"
```

4. Convert the VM to a template

```bash
qm template 5000
```
