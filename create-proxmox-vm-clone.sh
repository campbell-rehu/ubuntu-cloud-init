#!/bin/bash

function usage() {
  echo "Usage: $0 -i <VM_ID> -s <STORAGE_NAME> -I <IMAGE_PATH>"
  echo "  -i, --id           VM ID"
  echo "  -s, --storage      Storage name"
  echo "  -I, --imagePath    Image path"
  echo "  -h, --help         Display help"
  exit 1
}
function checkArgs() {
  if [ -z "$VM_ID" ] || [ -z "$STORAGE_NAME" ] || [ -z "$IMAGE_PATH" ]; then
    usage
  else
    run
  fi
}

function handleOptions() {
  while [ $# -gt 0 ]; do
    case $1 in
    -i | --id)
      VM_ID=$1
      ;;
    -s | --storage)
      STORAGE_NAME=$1
      ;;
    -I | --imagePath)
      shift
      IMAGE_PATH=$1
      ;;
    -h | --help)
      usage
      ;;
    *)
      echo "Invalid option: $1"
      usage
      ;;

    esac
    shift
  done
  checkArgs
}

function run() {
  qm create "$VM_ID" --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
  qm importdisk "$VM_ID" "$IMAGE_PATH" "$STORAGE_NAME"
  qm set "$VM_ID" --scsihw virtio-scsi-pci --scsi0 "$STORAGE_NAME":vm-"$VM_ID"-disk-0
  qm set "$VM_ID" --ide2 "$STORAGE_NAME":cloudinit
  qm set "$VM_ID" --boot c --bootdisk scsi0
  qm set "$VM_ID" --serial0 socket --vga serial0
  qm set "$VM_ID" --ipconfig0 "ip=dhcp"
  qm set "$VM_ID" --agent enabled=1,fstrim_cloned_disks=1
  qm resize "$VM_ID" scsi0 +10G
  qm set "$VM_ID" --cicustom "user=local:snippets/ubuntu-cloud-user-config.yaml"
  qm template "$VM_ID"
}

handleOptions "$@"
