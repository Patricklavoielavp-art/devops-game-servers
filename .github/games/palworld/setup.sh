#!/bin/bash
set -e

echo "=== Palworld — Setup complet ==="
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

BASE_DIR="$(dirname "$0")"
SERVICE_FILE="$BASE_DIR/systemd/palworld.service"

PAL_DIR="/opt/palworld"

echo "[1/6] Installation des dépendances..."
sudo apt update -y
sudo apt install -y steamcmd zip netcat

echo "[2/6] Création des dossiers..."
sudo mkdir -p "$PAL_DIR"
sudo chown -R "$USER":"$USER" "$PAL_DIR"

echo "[3/6] Installation du serveur Palworld..."
bash "$BASE_DIR/install.sh"

echo "[4/6] Copie du service systemd..."
sudo cp "$SERVICE_FILE" /etc/systemd/system/palworld.service

echo "[5/6] Permissions..."
chmod +x "$BASE_DIR"/*.sh

echo "[6/6] Activation du service..."
sudo systemctl daemon-reload
sudo systemctl enable palworld
sudo systemctl start palworld

echo "=== Installation terminée ==="
sudo systemctl status palworld --no-pager