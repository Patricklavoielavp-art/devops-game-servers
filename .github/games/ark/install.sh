#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
ENV_FILE="$ROOT/.env"

if[[! -f "$ENV_FILE"]]; then    
    echo "Missing .env file. Copy .env.exemple to .env and configure it."
    exit 1
fi

source "$ENV_FILE"

if[[ $EUID -ne 0]];then
  echo "Run as root"
  exit 1
fi

apt update 
apt insall -y lib32gcc-s1 crul tar

id -u "$ARK_USER" &>/dev/null || useradd -m -r -s /bin/bash "$ARK_USER"

mkdir -p "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$ARK_USER":"$ARK_USER" "$ARK_HOME" "$ARK_BACKUP_DIR" "$STEAMCMD_DIR"

if [[! -f "$STEAMCMD_BIN"]]; then
  cd "$STEAMCMD_DIR"
  curl -sql https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -o steamcmd.tar.gz
  tar -xzf steamcmd.tar.gz
  rm steamcmd.tar.gz
fi
sudo -u "$ARK_USER" "$STEAMCMD_BIN" +login anonymous \
  +force_install_dir "$ARK_HOME" \
  +app_update "$ARK_APP_ID" validate \
  +quit


