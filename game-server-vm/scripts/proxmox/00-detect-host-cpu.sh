#!/bin/bash
set -Eeuo pipefail

echo "🧠 Detecting host CPU topology..."

lscpu -e=CPU,CORE,SOCKET | awk 'NR>1' > /tmp/host_cpu_map.txt

echo "Detected CPU layout:"
column -t /tmp/host_cpu_map.txt

# Build physical core -> thread map
declare -A CORE_MAP

while read -r CPU CORE SOCKET; do 
    CORE_MAP[$CORE]="${CORE_MAP[$CORE]} $CPU"
done < /tmp/host_cpu_map.txt

echo 
echo "Physical core mapping."
for CORE in "${!CORE_MAP[@]}"; do
    echo "Core $CORE -> ${CORE_MAP[$CORE]}"    
done