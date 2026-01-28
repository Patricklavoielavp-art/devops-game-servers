#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#chargement es modules
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"

# Lecture du YAML
ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
ARK_APP_ID=$(yaml_get '.gameservers.ark.appid')
ARK_USER=$(yaml_get '.gameservers.ark.user')
STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"

# Vérification root
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root."
    exit 1
fi

log "Mise à jour d'ARK ASA via SteamCMD..."

sudo -u "$ARK_USER" "$STEAMCMD_BIN" +login anonymous \
    +force_install_dir "$ARK_HOME" \
    +app_update "$ARK_APP_ID" validate \
    +quit

success "Mise à jour ARK ASA terminée."

# Redémarrage automatique du service
SERVICE_NAME=$(yaml_get '.gameserver.ark.service_name')

log "Redémarrage du service systemd : $SERVICE_NAME ..."
service_restart "$SERVICE_NAME"

Success "Mise à jour + redémarrage completés."