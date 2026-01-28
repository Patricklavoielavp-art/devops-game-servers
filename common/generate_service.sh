#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

source "$SCRIPT_DIR/yaml.sh"
source "$SCRIPT_DIR/logging.sh"



GAME=$1

SERVICE_NAME=$(yaml_get ".gameservers.$GAME.service_name")
INSTALL_DIR=$(yaml_get ".gameservers.$GAME.install_dir")

if [[ -z "$SERVICE_NAME" || -z "$INSTALL_DIR" ]]; then
  error "SERVICE_NAME ou INSTALL_DIR vide (YAML invalide)"
  exit 1
fi

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

log "Génération du service systemd pour $GAME..."

sudo tee "$SERVICE_FILE" >/dev/null <<EOF
[Unit]
Description=$GAME Dedicated Server
After=network.target

[Service]
Type=simple
User=steam
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/start_${GAME}.sh
Restart=on-failure
RestartSec=10
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

success "Service généré : $SERVICE_FILE"

sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
