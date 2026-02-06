#!/usr/bin/env bash
set -e

APPID=$1
INSTALL_DIR=$2

if [ -z "$APPID" ] || [ -z "$INSTALL_DIR" ]; then
  echo "Usage: install-server.sh <APPID> <INSTALL_DIR>"
  exit 1
fi

sudo mkdir -p "$INSTALL_DIR"
sudo chown -R steam:steam "$INSTALL_DIR"

sudo -u steam /opt/game-servers/steamcmd/steamcmd.sh \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \
  +app_update "$APPID" validate \
  +quit

echo "Installed app $APPID in $INSTALL_DIR"