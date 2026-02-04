#!/bin/bash
set -Eeuo pipefail

echo "⚙️  Applying CPU performance tuning..."

apt install -y linux-tools-common linux-tools-$(uname -r)

for GOV in /sys/devices/system/cpu*/cpufreq/scaling_governor; do
    echo performance > "$GOV" || true
done

echo "✅ CPU governor set to performance"