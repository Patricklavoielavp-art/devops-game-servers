#!/bin/bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement des modules 
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"
source "$ROOT/../common/backup.sh"

# Lecture du YAML 
PAL_HOME=$(yaml_get '.gameservers.palworld.install_dir')
BACKUP_SRC=$(yaml_get '.gameservers.palworld.backup.source')
RETENTION=$(yaml_get '.gameservers.palworld.backup.retention_days')
DISCORD_WEBHOOK=$(yaml_get '.gameservers.palworld.monitoring.discord_webhook' || echo "")

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$PAL_HOME/backups"
BACKUP_FILE="$BACKUP_DIR/palworld_backup_$TIMESTAMP.tar.gz"

# Vérification root
if [[ $EUID -ne 0]]; then
    error "Ce script doit être exécuté en root."
    exit 1
fi

log "Démarrage du backup Palworld..."

#Vérification du dossier source 
if [[ ! -d "$BACKUP_SRC" ]]; then
    error "Le dossier de sauvegarde n'existe pas : $BACKUP_SRC"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Création du backup 
log "Compression du dossier Saved..."
tar -czf "$BACKUP_FILE" -C "$BACKUP_SRC" .

success "Backup créé : $BACKUP_FILE"

# Rotation automatique 
log "Néttoyage des anciens backups (rétention : $RETENTION jours)..."
find "$BACKUP_DIR" -type -f -mtime +"$RETENION" -name "*.tar.gz" -exec rm -f {} \;

success "Rotation terminée."

#Notification Discord 
if [[ -n "$DISCORD_WEBHOOK"]]; then
    log "Envoi de la notification Discord ..."
    curl -s -H "Content-Type: application/json" \
        -d "{\"content\": \"📦 Backup Palworld complété : \`$BACKUP_FILE\`\"}" \
        "$DISCORD_WEBHOOK" >/dev/null || warning "Échec de l'envoie Discord."
fi 

success "Backup Palworld terminé avec succès."