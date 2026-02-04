#!/bin/bash
set -Eeuo pipefail
source /tmp/proxmox_cpu_sets.env
source proxmox/config.env

pin_vm () {
    local VMID=$1
    local CPUSET=$2

    echo "📌 Pinning VM $VMID to CPUs : $CPUSET"
    qm set "$VMID" --cupset "$CPUSET"
}

pin_vm "$GAME_VM_ID" "$GAME_CPUSET"
pin_vm "$SERVER_VM_ID" "$SERVER_CPUSET"

echo "✅ VM pinning applied"