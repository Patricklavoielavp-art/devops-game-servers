#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

# Chargement des modules
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

# Lecture du YAML
ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
ARK_APP_ID=$(yaml_get '.gameservers.ark.appid')
ARK_USER=$(yaml_get '.gamesservers.ark.user')
STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"
ARK_BACKUP_DIR=$(yaml_get '.gameservers.ark.backup.source')

# Vérification root
if [[ $EUID -ne 0]]; then
    error "Ce script doit être exécuté en root"
    exit 1 
fi

log "Installation des dépendances..."
apt update
apt install -y lib32gcc-s1 curl tar

# Création de l'utilisateur ARK si absent
if ! id -u "$ARK_USER" &>/dev/null; then
    log "Création de l'utilisateur $ARK_USER ..."
    useradd -m -r -s /bin/bash "$ARK_USER"
fi

# Création des dossier
mkdir -p "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$ARK_USER":"$ARK_USER" "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"

# Installation de STEAMCMD si absent
if [[ ! -f "$STEAMCMD_BIN"]]; then
    log "Installation d'ARK ASA via SteamCMD"
    cd "$STEAMCMD_DIR"
    curl -sL https:// steamcdn-a.akamaihd.net/client/installer/steamcmd_lunix.tar.gz -o steamcmd.tar.gz
    rm steamcmd.tar.gz
fi

# Installer ARK via SteamCMD
log "Installation d'ARK ASA via SteamCMD ..."
sudo -u "$ARK_USER" "$STEAMCMD_BIN" +login anonymous \
    +force_install_dir "$ARK_HOME" \
    +app_update "$ARK_APP_ID" validate  \
    +quit

success "Installation de ARK ASA terminée."