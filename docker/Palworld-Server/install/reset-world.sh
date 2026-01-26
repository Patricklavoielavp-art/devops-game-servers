#!/bin/bash

SERVER_DIR="/servers/palword"
WORLD_DIR="$SERVER_DIR/Pal/Saved"

echo "ATTENTION : Cette Opération va SUPPRIMER le monde Palworld."
echo "Cette action est irrévesible."
read -p "Écrire OUI pour confirmer : " confirm

if [ "$confirm" != "OUI"]; then
    echo "Annulé."
    exit 1
fi

echo "[1/3] Arrêt du serveur"
sudo systemctl stop palworld.service

echo "[2/3] Suppression du monde"
rm -rf $WORLD_DIR

echo "[3/3] Redémarrage ud serveur"
sudo systemctl start palworld.service

echo "Monde Réinitialisé."