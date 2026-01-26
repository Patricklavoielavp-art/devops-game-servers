#!/bin/bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

if ! systemctl is-active --quiet palworld; then
    echo "[PALWORLD] Serveur down — redémarrage..."
    sudo systemctl restart palworld
else
    echo "[PALWORLD] Serveur OK"
fi
