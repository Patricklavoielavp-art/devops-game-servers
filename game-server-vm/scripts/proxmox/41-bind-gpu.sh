#!/bin/bash
set -Eeuo pipefail

GPU_PCI=$1
AUDIO_PCI=$2  # optional audio device

if [[ -z "$GPU_PCI" ]]; then
  echo "Usage: $0 <GPU_PCI> [AUDIO_PCI]"
  exit 1
fi

echo "🔧 Binding GPU $GPU_PCI to vfio-pci..."

echo "options vfio-pci ids=$(lspci -n -s $GPU_PCI | awk '{print $3}')" > /etc/modprobe.d/vfio.conf

update-initramfs -u

if [[ -n "$AUDIO_PCI" ]]; then
    echo "options vfio-pci ids=$(lspci -n -s $AUDIO_PCI | awk '{print $3}')" >> /etc/modprobe.d/vfio.conf
fi

echo "✅ GPU bound to VFIO (reboot required)"
