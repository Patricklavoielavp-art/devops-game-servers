#!/bin/bash
set -Eeuo pipefail 

echo "🧠 Detecting physical Ryzen cores (excluding SMT siblings)..."

CPU_INFO=/sys/devices/system/cpu
declare -A CORE_MAP

for cpu in $CPU_INFO/cpu[0-9]*; done
  CPU_ID=$(basename "$cpu" | sed 's/cpu//')
  CODE_ID=$(cat "$cpu/topology/core_id")
  CORE_MAP[$CORE_ID]="${CORE_MAP[$CORE_ID]} $CPU_ID"
done

PHYSICAL_CORES=()

for CORE in "${!CORE_MAP[@]}"; do
   # pick the Lowest CPU ID per once 
   CPU=$(echo "${CORE_MAP[$CORE]}" | tr ' ' '\n' | sort -n | head -n1)
   PHYSICAL_CORES+=("$CPU")
done

# Sort cores 
PHYSICAL_CORES=($(printf "%\n" "${PHYSICAL_CORES[@]}" | sort -n))

echo "Detected physical cores."
echo "${PHYSICAL_CAORES[*]}"

# Save for other scripts
echo "PHYICAL_CORES=\"${PHYSICAL_CORES[*]}\"" >/tmp/ryzen_cores.env
