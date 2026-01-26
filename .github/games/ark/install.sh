#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

ENV_FILE="$ROOT/.env"

# Vérification du .env
if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing .env file. Copy .env.example to .env and configure it."
    exit 1
fi

source "$ENV_FILE"

# Lecture du YAML
ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
ARK_APP_ID=$(yaml_get '.gameservers.ark.appid')
ARK_USER=$(yaml_get '.gameservers.ark.user')

STEAMCMD_DIR="/opt/steamcmd"
STEAMCMD_BIN="$STEAMCMD_DIR/steamcmd.sh"
ARK_BACKUP_DIR="$ARK_HOME/backups"

# Vérification root
if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

# Dépendances
apt update
apt install -y lib32gcc-s1 curl tar

# Création de l'utilisateur ARK si absent
id -u "$ARK_USER" &>/dev/null || useradd -m -r -s /bin/bash "$ARK_USER"

# Création des dossiers
mkdir -p "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$ARK_USER":"$ARK_USER" "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"

# Installation SteamCMD si absent
if [[ ! -f "$STEAMCMD_BIN" ]]; then
    cd "$STEAMCMD_DIR"
    curl -sL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o steamcmd.tar.gz
    tar -xzf steamcmd.tar.gz
    rm steamcmd.tar.gz
fi

# Installation ARK via SteamCMD
sudo -u "$ARK_USER" "$STEAMCMD_BIN" +login anonymous \
    +force_install_dir "$ARK_HOME" \
    +app_update "$ARK_APP_ID" validate \
    +quit

echo "ARK ASA installation completed successfully