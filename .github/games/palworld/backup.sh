#!/bin/bash

PAL_DIR="/opt/palworld"
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

BACKUP_DIR="$PAL_DIR/backups"

mkdir -p "$BACKUP_DIR"

DATE=$(date +%Y-%m-%d_%H-%M)
ZIP="$BACKUP_DIR/palworld_backup_$DATE.zip"

echo "[PALWORLD] Sauvegarde..."
zip -r "$ZIP" "$PAL_DIR/Pal/Saved"
echo "[PALWORLD] Sauvegarde terminée : $ZIP"