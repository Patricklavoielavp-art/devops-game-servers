#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"


SAVE_DIR="$PAL_HOME/Pal/Saved"

echo "[!] WARNING: This will delete the world save."
echo "Press CTRL+C to cancel."
sleep 3

systemctl stop palworld.service || true

rm -rf "$SAVE_DIR"

systemctl start palworld.service

echo "[+] World reset complete."