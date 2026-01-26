#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
source "$ROOT/.env"

TS=$(date +'%Y%m%d-%H%M%S')
FILE="$PAL_BACKUP_DIR/palworld-$TS.tar.gz"

echo "[+] Creating backup: $FILE"

systemctl stop palworld.service || true

tar -czf "$FILE" -C "$PAL_HOME" .

systemctl start palworld.service || true

echo "[+] Backup complete."