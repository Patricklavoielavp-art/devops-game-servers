#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"

ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
ARK_APP_ID=$(yaml_get '.gameservers.ark.appid')
ARK_USER=$(yaml_get '.gameservers.ark.user')
ARK_BACKUP_DIR=$(yaml_get '.gameservers.ark.backup.source')

STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"

if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root"
    exit 1
fi

log "Installation des dépendances..."
apt update
apt install -y lib32gcc-s1 lib32stdc++6 curl tar ca-certificates

if ! id -u "$ARK_USER" &>/dev/null; then
    log "Création de l'utilisateur $ARK_USER"
    useradd -m -r -s /bin/bash "$ARK_USER"
fi

mkdir -p "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$ARK_USER":"$ARK_USER" "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"

if [[ ! -f "$STEAMCMD_BIN" ]]; then
    log "Installation de SteamCMD"
    cd "$STEAMCMD_DIR"
    curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o steamcmd.tar.gz
    tar -xzf steamcmd.tar.gz
    rm steamcmd.tar.gz
fi

log "Installation d'ARK Survival Ascended..."
runuser -u "$ARK_USER" -- "$STEAMCMD_BIN" \
    +login anonymous \
    +force_install_dir "$ARK_HOME" \
    +app_update "$ARK_APP_ID" validate \
    +quit

success "Installation ARK ASA terminée"
