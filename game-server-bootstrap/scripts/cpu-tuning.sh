#!/usr/bin/env bash
set -e

echo "==== CPU Tuning for game servers ===="

# CPU pinning: Ark → CPU0-1, Palworld → CPU2-3
ARK_PID=$(pgrep -f "arkserver")
PAL_PID=$(pgrep -f "palworldserver")

if [ "$ARK_PID" ]; then
    taskset -cp 0-1 $ARK_PID
fi
if [ "$PAL_PID" ]; then
    taskset -cp 2-3 $PAL_PID
fi

# Set performance governor
for CPU in /sys/devices/system/cpu/cpu[0-3]; do
    echo performance | sudo tee $CPU/cpufreq/scaling_governor
done

echo "CPU pinning and governor tuning applied"
