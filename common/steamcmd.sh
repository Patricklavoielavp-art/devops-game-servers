#!/bin/bash
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )")/logging.sh"

steam_update() {
    local install_dir=$1
    local appid=$2

    log "Mise à jour SteamCMD..."
    steamcmd +force_install_dir "$install_dir" +login anonymous +app_update "$appid" validate +quit
    success "Mise à jour terminée"
}

steam_install() {
    local install_dir=$1
    local appid=$2

    log "Installation SteamCMD du serveur..."
    steamcmd +force_install_dir "$install_dir" +login anonymous +app_update "$appid" validate +quit
    success "Installation terminée"
}