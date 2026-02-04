#!/bin/bash
set -Eeuo pipefail

echo "🖥 Detecting PCI GPUs..."

lspci -nn | grep -E "VGA|3D" | while read -r line; do 
    PCI_ID=$(echo "$line" | awk '{print $1}')
    NAME=$(echo "$line" | cut -d' ' -f2-)
    echo "Found GPU: $NAME at $PCI_ID"
done 
