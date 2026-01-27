#!/bin/bash
set -e

echo "=== Setup global Linux — ARK + Palworld ==="

echo "[1/5] Installation des dépendances communes..."
sudo apt update -y
sudo apt install -y steamcmd zip netcat

echo "[2/5] Création de l'utilisateur steam (si absent)..."
if ! id "steam" &>/dev/null; then
    sudo useradd -m steam
fi

echo "[3/5] Setup ARK..."
bash ark/setup.sh

echo "[4/5] Setup Palworld..."
bash palworld/setup.sh

echo "[5/5] Vérification des services..."
systemctl status ark --no-pager || true
systemctl status palworld --no-pager || true

echo "=== Installation complète ARK + Palworld terminée ==="
