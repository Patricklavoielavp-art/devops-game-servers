#!/bin/bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

ARK_DIR="/opt/ark"
ARK_BINARY="$ARK_DIR/ShooterGame/Binaries/Linux/ArkAscendedServer"

MAP="TheIsland_WP"
SESSION_NAME="Zbudevwe_ISLAND"
SESSION_PSW="XXX"
PORT=7777
QUERY_PORT=27015
RCON_PORT=27020
RCON_ENABLED="True"

cd "$ARK_DIR" || exit 1

"$ARK_BINARY" \
    "MAP?listen?SessionName=$SESSION_NAME?ServerPassword=$SESSION_PSW?ServerAdminPassword="183Lavoie$" \
    -server \
    -log \
    -Port=$PORT \
    -QueryPort=$QUERY_PORT \
    -RCONPort=$RCON_PORT \
    -RCONEnabled=$RECON_ENABLED