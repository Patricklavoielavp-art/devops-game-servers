#!/bin/bash
set -e

PAL_DIR="/opt/palworld"
APPID="2394010"
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

echo "[PALWORLD] Installation..."

sudo mkdir -p "$PAL_DIR"
sudo chown -R "$USER":"$USER" "$PAL_DIR"

echo "[PALWORLD] Installation de SteamCMD..."
sudo apt update -y
sudo apt install -y steamcmd

echo "[PALWORLD] Téléchargement du serveur..."
steamcmd +force_install_dir "$PAL_DIR" +login anonymous +app_update "$APPID" validate +quit

echo "[PALWORLD] Installation terminée."
echo "[PALWORLD] Pour démarrer : sudo systemctl start palworld"