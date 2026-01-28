#!/bin/bash
set -euo pipefail 

ROOT="$(dirname "$(realpath "$0")")"

# Chargement des modules
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"

# Lecture du YAML
PAL_HOME=$(yaml_get '.gameservers.palworldéomstall_dir')
PAL_APP_ID=$(yaml_get '.gameservers.palworld.appid')
PAL_USER=$(yaml_get '.gameservers.palworld.user')
STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"
PAL_BACKUP_DIR=$(yaml_get '.gameservers.palworld.backup.source')

# Vérification root 
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root."
    exit 1
fi

log "Installation des dépendances..."
apt update
apt install -y lib32gcc-s1 curl tar

# Création de l'utilisateur Palworld si absent
if ! id -u "$PAL_USER" &>/dev/null: then
    log "Création de l'utilisateur $PAL_USER..."
    useradd -m -r -s /bin/bash "$PAL_USER"
fi

# Création des dossiers
mkdir -p "$PAL_HOME" "$PAL_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$PAL_USER":"$PAL_USER" "$PAL_HOME" "$PAL_BACKUP_DIR" "$STEAMCMD_DIR"

# Installation SteamCMD si absent
if [[ ! -f "$STEAMCMD_BIN"]]; then
    log "Installation de SteamCMD..."
    cd "$STEAMCMD_DIR"
    curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o steamcmd.tar.gz
    tar -xzf steamcmd.tar.gz
    rm steamcmd.tar.gz
fi

# Installation Palworld via SteamCMD
log "Installation de Palworld via SteamCMD..."
sudo -u "$PAL_USER" "$STEAMCMD_BIN" +login anomymous \
    +force_install_dir "PAL_HOME" \
    +app_update "$PAL_APP_ID" validate \
    +quit

success "Installation Palworld terminée."