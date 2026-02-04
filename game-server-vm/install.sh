#!/bin/bash
set -Eeuo pipefail 

echo "🚀 Starting full server VM setup..."

# ----------- 0. Load configs --------------
if [[ ! -d config ]]; then
    echo "❌ Missing config/ folder"
    exit 1
fi

source config/ark.env || true
source config/palworld.env || true
source config/proxmox.env || true

# ------------ 1. Check root ----------------
echo "🔹 Checking root privileges..."
if [[ $EUID -ne 0 ]]; then
    echo "❌ Must run as root"
    exit 1
fi

# ------------ 2. System prerequisites ------
echo "🔹 Creating steam user..."
id -u steam &>/dev/null || useradd -m -s /bin/bash steam

# ------------ 4. UFW automatic open ports ----
echo "🔹 Configuring UFW..."
ufw allow 22/tcp
ufw allow 7777/udp
ufw allow 27015/udp
ufw --force enable

# ----- 5. CPU Timing ------------------------
echo "🔹 Setting CPU governor to performance..."
for GOV in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do 
    echo performance > "$GOV" || true
done 

# ------------- 6. Detect Ryzen cores ------------
echo "🔹 Detecting physical cores..."
CPU_INFO=/sys/devices/system/cpu
declare -A CORE_MAP
for cpu in $CPU_INFO/cpu[0-9]*; do
    CPU_ID=$(basename "$cpu" | sed 's/cpu//')
    CORE_ID=$(cat "$cpu/topology/core_id")
    CORE_MAP[$CORE_ID]="${CORE_MAP[$CORE_ID]} $CPU_ID"
done

PHYSICAL_CORES=()
for CORE in "${!CORE_MAP[@]}"; do
    CPU=$(echo "${CORE_MAP[$CORE]}" | tr ' ' '\n' | sort -n |  head -n1)
    PHYSICAL_CORES+=("$CPU")
done
PHYSICAL_CORES=($(printf "%s\n" "${PHYSICAL_CORES[@]}" | sort -n))
echo "Detected cores: ${PHYSICAL_CORES[*]}"

# -------------- 7. Assign cores -------------------
GAME_CORES=("${PHYSICAL_CORES[@]:0:2}")    # first two for host/VM gaming
SERVER_CORES=("${PHYSICAL_CORES[@]:2:2}") # next two for server VM

echo "🎮 Gaming cores: ${GAME_CORES[*]}"
echo "🧑‍🌾 Server cores: ${SERVER_CORES[*]}"

echo "GAME_CPUSET=${GAME_CORES[*]}" > /tmp/cpu_sets.env
echo "SERVER_CPUSET=${SERVER_CORES[*]}" >> /tmp/cpu_sets.env

# ---- 8. Fail2Ban setup ----
echo "🔹 Installing Fail2Ban..."
apt install -y fail2ban
cat >/etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = ssh
EOF
systemctl enable fail2ban
systemctl restart fail2ban

# ---- 9. SteamCMD + game install (modular) ----
echo "🔹 Installing ARK and Palworld..."
 ./scripts/10-ark-install.sh
 ./scripts/11-palworld-install.sh

# ---- 10. Systemd services ----
echo "🔹 Enabling systemd services..."
 ./scripts/20-ark-service.sh
 ./scripts/21-palworld-service.sh

 # ---- 11. Live update script available ----
echo "🔹 Live update ready: ./scripts/50-live-update.sh"

# ---- 12. Optional Proxmox host-level pinning ----
if [[ "${PROXMOX:-false}" == "true" ]]; then
    echo "🔹 Running Proxmox host pinning..."
    ./scripts/proxmox/00-detect-host-cpu.sh
    ./scripts/proxmox/10-calc-core-groups.sh
    ./scripts/proxmox/20-pin-vm.sh
    ./scripts/proxmox/30-isolate-host.sh

    if [[ -n "${GPU_PCI:-}" ]]; then
        echo "🔹 Preparing GPU passthrough..."
        ./scripts/proxmox/41-bind-gpu.sh "$GPU_PCI" "$AUDIO_PCI"
        ./scripts/proxmox/42-assign-gpu-vm.sh
        echo "⚠️ Reboot host before starting gaming VM"
    fi
fi

echo "✅ Full installation complete!"
echo "Use: systemctl start ark palworld"
echo "Use: ./scripts/50-live-update.sh <ark|palworld> for updates"

