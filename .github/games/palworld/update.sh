#!/bin/bash
set -e

PAL_DIR="/opt/palworld"
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

APPID="2394010"

echo "[PALWORLD] Mise à jour..."
steamcmd +force_install_dir "$PAL_DIR" +login anonymous +app_update "$APPID" +quit
echo "[PALWORLD] Mise à jour terminée."

sudo systemctl restart palworld
