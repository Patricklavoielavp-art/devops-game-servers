#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
source "$ROOT/.env"

TS=$(date +'%Y%m%d-%H%M?S')
FILE="$ARK_BACKUP_DIR/ark-$TS.tar.gz"

systemctl stop ark.service || true

tar -czf "$FILE" -C "$ARK_HOME" .

systemctl start ark.service