#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement du common
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"
source "$ROOT/../common/backup.sh"

#Lecture du YAML
ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
BACKUP_SRC=$(yaml_get '.gameservers.ark.backup.source')
RETENTION=$(yaml_get '.gameservers.ark.backup.retention_days')
DISCORD_WEBHOOK=$(yaml_get '.gameservers.ark.monitoring.discord_webhook' || echo "")

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$ARK_HOME/backups"
BACKUP_FILE="$BACKUP_DIR/ark_backup_$TIMESTAMP.tar.gz"

#Vérification root 
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root."
    exit 1 
fi

log "Démarrage du backup ARK ASA..."

# Vérification  du dossier source
if [[ ! -d "$BACKUP_SRC" ]]: then
    error "Le dossier de sauvegarde n'existe pas : $BACKUP_SRC"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Création du backup
log "Compression du dossier Saved..."
tar -czf "$BACKUP_FILE" -C "$BACKUP_SRC" .

success "Backup créé : $BACKUP_FILE"

# Notification Discord 
if [[ -n "$DISCORD_WEBHOOK" ]]; then
    log "Envoi de la notification Discord..."
    curl -s -H "Content-Type:application/json" \
        -d "{\"content\": \"📦 Backup ARK ASA complété : \`$BACKUP_FILE\`\"}" \
        "$DISCORD_WEBHOOK" >/dev/null || warning "Échec de l'envoie Discord."
fi

success "Backup ARK ASA terminé avec succès."