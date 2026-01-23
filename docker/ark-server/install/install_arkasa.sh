#!/bin/bash

USER_NAME="gameserver"
ARK_DIR="/home/$USER_NAME/servers/arkasa"
APP_ID_ARK_ASA="2430930"

mkdir -p "$ARK_DIR"

sudo -u "$USER_NAME" steamcmd +login anonymous \
    +force_install_dir "$ARK_DIR" \
    +app_update "$APP_ID_ARK_ASA" validate \
    +quit
