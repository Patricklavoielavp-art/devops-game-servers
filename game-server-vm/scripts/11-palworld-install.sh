#!/bin/bash
set -Eeuo pipefail

source ./config/vm.env
source ./config/palword.env

INSTALL_PATH="$INSTALL_ROOT/$PALWORLD_DIR"
mkdir -p "$INTALL_PATH"
chown -R steam:steam "$INSTALL_ROOT"

echo "⏳ Installing Palworld server..."

sudo -u steam /opt/steamcmd/steamcmd \
+login anonymous 
+force_install_dir "$INSTALL_PATH" \
+app_update "$PALWORLD_APP_ID" validate \
+quit