#!/bin/bash

echo "[1/2] Arrêt du serveur"
sudo systemctl stop palworld.service

echo "[2/2]"
sudo sytemctl start palworld.service

echo "Redémarrage terminé."
