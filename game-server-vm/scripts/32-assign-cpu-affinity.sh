#!/bin/bash
set -Eeuo pipefail

source /tmp/ryzen_cores.env

# Remove core 0 (kernel)
CORES=("${PHYSICAL_CORES[@]:1}")

ARK_CORES="${CORES[0]} ${CORES[1]}"
PAL_CORES="${CORES[2]}"

echo "ARK_CORES=\"$ARK_CORES\""
echo "PAL_CORES=\"$PAL_CORES\""

cat >/etc/game-cpu.env <<EOF
ARK_CPU_AFFINITY="$ARK_CORES"
PAL_CPU_AFFINITY="$PAL_CORES"
EOF
