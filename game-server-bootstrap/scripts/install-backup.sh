#!/usr/bin/env bash
set -e

BACKUP_DIR="/backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/ark.tar.gz" /opt/game-servers/ark
tar -czf "$BACKUP_DIR/palworld.tar.gz" /opt/game-servers/palworld
