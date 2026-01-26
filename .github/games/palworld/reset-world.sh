#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
source "$ROOT/.env"

SAVE_DIR="$PAL_HOME/Pal/Saved"

echo "[!] WARNING: This will delete the world save."
echo "Press CTRL+C to cancel."
sleep 3

systemctl stop palworld.service || true

rm -rf "$SAVE_DIR"

systemctl start palworld.service

echo "[+] World reset complete."