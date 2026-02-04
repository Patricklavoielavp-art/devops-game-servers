#!/bin/bash
set -Eeuo pipefail

source ./config/arv.env
source ./config/palworld.env

# Install ufw if missing 
if ! command  -v ufw &>/dev/null; then
  apt update
  apt install -f ufw
fi

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Always allow SSH (DO THIS FIRST)
ufw allow ssh comment 'Allow SSH'

# ------------ ARK ------------------
ufw allow "$ARK_PORT"/udp comment 'ARK Game Port'
ufw allow "$ARK_QUERY_PORT"/udp comment 'ARK Query Port'
ufw allow "$ARK_RCON_PORT"/tcp comment 'ARK RCON Port'

# ------------ Palworld -------------
ufw allow "$PALWORLD_PORT"/udp comment 'Palworld Game Port'
ufw allow "$PALWORLD_ADMIN_PORT"/tcp comment 'Palworld Admin'

# Enable ufw safety
if ufw status | grep -q inactive; then
  echo "⚠️  Enabling UFW..."
  ufw --force enable
else 
  echo "ℹ️  UFW already enabled"
fi

ufw status verbose