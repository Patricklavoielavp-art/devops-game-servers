#!/bin/bash
set -Eeuo pipefail
source /tmp/proxmox_cpu_sets.env

echo "🧱 Isolating host processes from server cores..."

systemctl set-property --runtime system.slice AllowedCPUs=$GAME_CPUSET
systemctl set-property --runtime user.slice AllowedCPUs=$GAME_CPUSET
systemctl set-property --runtime init.slice AllowedCPUs=$GAME_CPUSET

echo "✅ Host isolation active (runtime only)"