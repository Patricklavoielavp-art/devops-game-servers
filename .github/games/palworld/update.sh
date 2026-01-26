#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
source "$ROOT/.env"

echo "[+] Stopping Palworld service..."
systemctl stop palworld.service || true

echo "[+] Updating Palworld server..."
sudo -u "$PAL_USER" "$STEAMCMD_BIN" +login anonymous \
  +force_install_dir "$PAL_HOME" \
  +app_update "$PAL_APP_ID" \
  +quit

echo "[+] Restarting service..."
systemctl start palworld.service

echo "[+] Update complete."