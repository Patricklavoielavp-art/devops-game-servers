#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
ENV_FILE="$ROOT/.env"

if[[! -f "$ENV_FILE"]]; then    
    echo "Missing .env file. Copy .env.exemple to .env and configure it."
    exit 1
fi

source "$ENV_FILE"

if [[$EUID -ne 0]]; then
    echo "Run this script as root(sudo)"
    exit 1
fi

echo "[+] Installing dependencies ..."
apt update
apt install -y lib32gcc-s1 curl tar

echo "[+] Creating user $PAL_USER..."
id -u "$PAL_USER" &>/dev/null || useradd -m -r -s /bin/bash "$PAL_USER"

echo "[+] Creating directories..."
mkdir -p "$PAL_HOME" "$PAL_BACKUP_DIR" "$STEAMCMD_DIR"
chown -R "$PAL_USER":"$PAL_USER" "$PAL_HOME" "$PAL_BACKUP_DIR" "$STEAMCMD_DIR"

if [[ ! -f "$STEAMCMD_BIN" ]]; then
  echo "[+] Installing SteamCMD..."
  cd "$STEAMCMD_DIR"
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" -o steamcmd.tar.gz
  tar -xzf steamcmd.tar.gz
  rm steamcmd.tar.gz
fi

echo "[+] Installing Palworld server..."
sudo -u "$PAL_USER" "$STEAMCMD_BIN" +login anonymous \
  +force_install_dir "$PAL_HOME" \
  +app_update "$PAL_APP_ID" validate \
  +quit

echo "[+] Installation complete."
echo "Next steps:"
echo " - Configure systemd service"
echo " - Start the server"


