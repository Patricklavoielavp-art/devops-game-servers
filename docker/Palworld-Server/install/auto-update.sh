#!/bin/bash
set -e

SERVER_DIR="/servers/palworld"
STEAMCMD_DIR="/servers/steamcmd"
SERVICE="palworld.service"

echo "[1/4] Arrêt du serveur"
sudo systemctl stop $SERVICE

echo "[2/4] Mise à jour via SteamCMD"
$STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +app_update 2394010 validate \
    +quit

echo "[3/4] Redémarrage du serveur "
sudo systemctl start $SERVICE

echo "[4/4] Mise à jour terminée"


