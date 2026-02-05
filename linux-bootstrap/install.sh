#!/bin/bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$ROOT_DIR/scripts"
CONFIG_DIR="$ROOT_DIR/config"
LOG_FILE="/var/log/linux-bootstrap.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================"
echo "🚀 Linux Enterprise Bootstrap Starting"
echo "🕒 $(date)"
echo "========================================"

#######################################
# 0️⃣ Root check
#######################################
"$SCRIPT_DIR/00-check-root.sh"

#######################################
# 1️⃣ Load config
#######################################
for cfg in server.env ssh.env firewall.env; do
  if [[ ! -f "$CONFIG_DIR/$cfg" ]]; then
    echo "❌ Missing config/$cfg"
    exit 1
  fi
  source "$CONFIG_DIR/$cfg"
done

echo "✅ Configuration loaded"

#######################################
# 2️⃣ Base system setup
#######################################
BASE_SCRIPTS=(
  "01-system-update.sh"
  "02-users.sh"
  "06-timezone-ntp.sh"
  "03-ssh-hardening.sh"
  "04-firewall.sh"
  "05-fail2ban.sh"
)

echo "🔧 Running base system setup..."
for script in "${BASE_SCRIPTS[@]}"; do
  echo "➡ $script"
  "$SCRIPT_DIR/$script"
done

#######################################
# 3️⃣ Enterprise hardening layer
#######################################
if [[ "${ENABLE_ENTERPRISE_HARDENING:-false}" == "true" ]]; then
  echo "🏢 Applying enterprise hardening..."

  [[ "${ENABLE_KERNEL_HARDENING:-true}" == "true" ]] \
    && "$SCRIPT_DIR/10-kernel-hardening.sh"

  [[ "${ENABLE_AUTO_UPDATES:-true}" == "true" ]] \
    && "$SCRIPT_DIR/11-unattended-upgrades.sh"

  [[ "${ENABLE_AUDITD:-true}" == "true" ]] \
    && "$SCRIPT_DIR/12-auditd.sh"

  [[ "${ENABLE_APPARMOR:-true}" == "true" ]] \
    && "$SCRIPT_DIR/13-apparmor.sh"

  [[ "${ENABLE_LOGROTATE:-true}" == "true" ]] \
    && "$SCRIPT_DIR/14-logrotate.sh"

  [[ "${ENABLE_FIPS:-false}" == "true" ]] \
    && "$SCRIPT_DIR/15-fips.sh"

  [[ "${ENABLE_VAULT_AGENT:-false}" == "true" ]] \
    && "$SCRIPT_DIR/16-vault-agent.sh"

  [[ "${ENABLE_OSQUERY:-false}" == "true" ]] \
    && "$SCRIPT_DIR/17-osquery.sh"
else
  echo "ℹ️ Enterprise hardening disabled"
fi

#######################################
# 4️⃣ Optional services
#######################################
OPTIONAL_SCRIPTS=()

[[ "${ENABLE_CUSTOM_PACKAGES:-false}" == "true" ]] \
  && OPTIONAL_SCRIPTS+=("09-custom-packages.sh")

[[ "${ENABLE_DOCKER:-false}" == "true" ]] \
  && OPTIONAL_SCRIPTS+=("07-docker.sh")

[[ "${ENABLE_MONITORING:-false}" == "true" ]] \
  && OPTIONAL_SCRIPTS+=("08-monitoring.sh")

if [[ ${#OPTIONAL_SCRIPTS[@]} -gt 0 ]]; then
  echo "🧩 Installing optional services..."
  for script in "${OPTIONAL_SCRIPTS[@]}"; do
    echo "➡ $script"
    "$SCRIPT_DIR/$script"
  done
else
  echo "ℹ️ No optional services enabled"
fi

#######################################
# 5️⃣ Final validation
#######################################
echo "🔍 Final system status:"
ufw status verbose || true
systemctl is-active fail2ban || true
systemctl is-active auditd || true
systemctl is-active apparmor || true

#######################################
# 6️⃣ Completion
#######################################
echo "========================================"
echo "✅ Enterprise Bootstrap COMPLETE"
echo "🧾 Log file: $LOG_FILE"
echo "👤 Admin user: $NEW_USER"
echo "🔐 SSH port: $SSH_PORT"
echo "🏷 Role: ${SERVER_ROLE:-unset}"
echo "========================================"

echo "⚠️ NEXT STEPS:"
echo "• Open a NEW SSH session before closing this one"
echo "• Log out/in if Docker was installed"
echo "• Reboot recommended (kernel / sysctl / auditd)"
