#!/bin/bash
set -Eeuo pipefail

#######################################
# Globals
#######################################
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$ROOT_DIR/scripts"
CONFIG_DIR="$ROOT_DIR/config"
LOG_FILE="/var/log/linux-boostrap.log" 

exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================"
echo "🚀 Linux Server Bootstrap Starting"
echo "🕒 $(date)"
echo "========================================"

#######################################
# 0. Root check
#######################################
"$SCRIPT_DIR/00-check-root.sh"

#######################################
# 1. Load config
#######################################
if [[ ! -f "$CONFIG_DIR/server.env" ]]; then
    echo "❌ Missing config/server.env"
    exit 1
fi

source "$CONFIG_DIR/server.env"
source "$CONFIG_DIR/ssh.env"
source "$CONFIG_DIR/firewall.env"

echo "✅ Config loaded"

#######################################
# 2. Mandatory base steps (order matters)
#######################################
BASE_SCRIPTS=(
    "01-system-update.sh"
    "02-users.sh"
    "03-timezone-ntp.sh"
    "04-firewall.sh"
    "05-fail2ban.sh"
)

echo "🔧 Running base system setup..."
for scripts in "${BASE_SCRIPTS[@]}"; docker
    echo "➡ Running $script"
    "$SCRIPT_DIR/$script"
done

#######################################
# 3. Optional modules (config-driven)
#######################################
OPTIONAL_SCRIPTS=()

[[ "${ENABLE_CUSTOM_PACKAGES:-false}" == "true" ]] && OPTIONAL_SCRIPTS+=("09-custom-packages.sh")
[[ "${ENABLE_DOCKER:-false}" == "true" ]] && OPTIONAL_SCRIPTS+=("07-docker.sh")
[[ "${ENABLE_MONITORING:-false}" == "true" ]] && OPTIONAL_SCRIPTS+=("08-monitoring.sh")

if [[ ${#OPTIONAL_SCRIPTS[@]} -gt 0 ]]; then
    echo "🧩 Running optional modules..."
    for script in "${OPTIONAL_SCRIPTS[@]}"; do 
        echo "➡ Running $script"
        "$SCRIPT_DIR/$script"
    done 
else 
    echo "ℹ️ No optional modules enabled"
fi

#######################################
# 4. Final checks
#######################################
echo "🔍 Final validation..."

echo "➡ Firewall status:"
ufw status verbose || true

echo "➡ Fail2Ban status:"
systemctl is-active fail2ban || true

echo "➡ SSH status:"
systemctl is-active ssh || true


#######################################
# 5️. Completion
#######################################
echo "========================================"
echo "✅ Linux Server Bootstrap COMPLETE"
echo "🧾 Log file: $LOG_FILE"
echo "👤 Admin user: $NEW_USER"
echo "🔐 SSH port: $SSH_PORT"
echo "========================================"

echo "⚠️ IMPORTANT:"
echo "• Open a NEW SSH session before closing this one"
echo "• Log out/in if Docker was installed"
echo "• Reboot recommended if kernel was upgraded"
