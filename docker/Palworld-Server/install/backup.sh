#!/bin/bash
set -e

SERVER_DIR="/servers/palworld"
BACKUP_DIR="/servers/palworld-backups"
DATE=$(date +"%Y-%m-%d-%H-%M")

mkdir -p $BACKUP_DIR

echo "Création de la sauvegarde ..."
tar -cvxf $BACKUP_DIR/palworld_backup_$DATE.taz.gz \
    $SERVER_DIR/Pal/Saved

echo "Sauvegarde terminée : $BACKUP_DIR/palworld_backup_$DATE.taz.gz"
