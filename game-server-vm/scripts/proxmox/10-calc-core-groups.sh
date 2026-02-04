#!/bin/bash
set -Eeuo pipefail

source proxmox/config.env

echo "📐 Calculating core groups..."

# Read core map again 
declare -A CORE_MAP
while read -r CPU CORE SOCKET; do
    CORE_MAP[$CORE]="${CORE_MAP[$CORE]} $CPU"
done < <(lscpu -e=CPU,CORE,SOCKET | awk 'NR>1')

# Sort physical cores 
PHYSICAL_CORES=($(printf "%s\n" "${!CORE_MAP[@]}" | sort -n ))

TOTAL_CORES=${#PHYSICAL_CORES[@]}

if (( SERVER_PHYSICAL_CORES >= TOTAL_CORES )); then
  echo "❌ SERVER_PHYSICAL_CORES too large"
  exit 1
fi

# Assign last N cores to servers
SERVER_CORES=("${PHYSICAL_CORES[@]: -$SERVER_PHYSICAL_CORES}")

GAME_CORES=("${PHYSICAL_CORES[@]:0:$((TOTAL_CORES-SERVER_PHYSICAL_CORES))}")


expand_threads () {
    local list=("$@")
    local out=()
    for CORE in "${list[@]}"; do
        for CPU in ${CORE_MAP[$CORE]};do
            out+=("$CPU")
        done
    done
    echo "${out[*]}"
}

SERVER_CPUSET=$(expand_threads "${SERVER_CORE[@]}")
GAME_CPUSET=$(expand_threads "${GAME_CORES[@]}")

cat >/tmp/proxmox_cpu_sets.env <<EOF
SERVER_CPUSET="$SERVER_CPUSET"
GAME_CPUSET="$GAME_CPUSET"
EOF

echo "🎮 Gaming cores : $GAME_CPUSET"
echo "🧑‍🌾 Server cores : $SERVER_CPUSET"