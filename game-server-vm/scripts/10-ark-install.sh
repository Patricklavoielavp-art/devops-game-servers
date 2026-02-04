#!/bin/bash
set -Eeuo pipefail

source ./config/vm.env
source ./config.ark.env

INSTALL_PATH="$INSTALL_ROOT/$ARK_DIR"
mkdir -p "$INSTALL_PATH"
chown -R steam:steam "$INSTALL_ROOT"


echo "⏳ Installing ARK server..."

sudo -u steam /opt/steamcmd/steamcmd \
    +login anonymous \
    +force_install_dir "$INSTALL_PATH" \
    +app_update "ARK_APP_ID" validate \
    +quit