#!/bin/bash
set -e

SERVER_DIR="/servers/palworld"
STEAMCMD_DIR="/servers/steamcmd"

echo "[1/3] Arrêt du serveur"
sudo systemctl stop palworld.service

echo "[2/3] Mise à jour via SteamCMD"
$STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +app_update 2394010 validate \
    +quit

echo "[3/3] Redémarrage du serveur"
sudo systemctl start palworld.service

echo "Mise a jour terminée."