#!/bin/bash
set -e
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

echo "====== ARK ASA - Setup Complet ========"

INSTALL_DIR=$(yaml_get ".gameservers.ark.install_dir")
APPID=$(yaml_get ".gameservers.ark.appid")

echo "[1/6] Installation des dépendances..."
sudo apt update -y
sudo apt install steamcmd zip netcat


echo "[2/6] Création des dossiers ..."
sudo mkdir -p "$ARK_DIR"
sudo chown -R "$USER":"$USER" "$ARK_DIR"

echo "[3/6] Intallation du serveur ARK ..."
steam_install "$INSTALL_DIR" "$APPID"

echo "[4/6] Copie du service systemd ..."
bash ../common/generate_service.sh ark

echo "[5/6] Permissions ..."
chmod +x "$BASE_DIR/*.sh

echo "[6/6] Activation du service ..."
sudo systemctl deamon-reload
sudo systemctl enable ark
sudo systemctl start ark

echo "======= Installation termninée ========="
sudo systemctl status ark --no-pager