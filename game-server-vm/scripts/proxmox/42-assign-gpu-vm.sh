#!/bin/bash
set -Eeuo pipefail
source proxmox/config.env

if [[ -z "$GPU_PCI" ]]; then
  echo "Please set GPU_PCI in config.env"
  exit 1
fi

echo "📌 Assigning GPU $GPU_PCI to VM $GAME_VM_ID"

qm set "$GAME_VM_ID" --hostpci0 "$GPU_PCI,pcie=1"