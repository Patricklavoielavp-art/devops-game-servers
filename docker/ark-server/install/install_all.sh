#!/bin/bash

USER_NAME="gameserver"
ARK_DIR="/home/$USER_NAME/servers/arkasa"
APP_ID_ARK_ASA="2430930"

sudo apt update && sudo apt install -y steamcmd

mkdir -p "$ARK_DIR"

sudo -u "$USER_NAME" steamcmd +login anonymous \
  +force_install_dir "$ARK_DIR" \
  +app_update "$APP_ID_ARK_ASA" validate \
  +quit

sudo ufw allow 7777/udp
sudo ufw allow 27015/udp

echo "Installation ARK ASA terminée."
echo "Démarre avec : sudo systemctl start arkasa"