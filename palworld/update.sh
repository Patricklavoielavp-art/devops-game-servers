#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

# Chargement des modules
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"
source "$ROOT/../COMMON/system.sh"

# Lecture du YAML
PAL_HOME=$(yaml_get '.gameservers.palworld.install_dir')
PAL_APP_ID=$(yaml_get '.gameservers.palworld.appid')
PAL_USER=$(yaml_get '.gameservers.palworld.user')
SERVICE_NAME=$(yaml_get '.gameservers.palworld.service_name')

STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"

# Vérification root
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root."
    exit 1
fi

log "Mise à jour du serveur Palworld via SteamCMD…"

sudo -u "$PAL_USER" "$STEAMCMD_BIN" +login anonymous \
    +force_install_dir "$PAL_HOME" \
    +app_update "$PAL_APP_ID" validate \
    +quit

success "Mise à jour Palworld terminée."

# Redémarrage automatique du service
log "Redémarrage du service systemd : $SERVICE_NAME"
service_restart "$SERVICE_NAME"

success "Mise à jour + redémarrage complétés."