#!/bin/bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

# Chargement du COMMON
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"

# Lecture du YAML
ARK_HOME=$(yaml_get '.gameservers.ark.install_dir')
MAP=$(yaml_get '.gameservers.ark.settings.map')
SESSION_NAME=$(yaml_get '.gameservers.ark.settings.session_name')
ADMIN_PASSWORD=$(yaml_get '.gameservers.ark.settings.admin_password')
SERVER_PASSWORD=$(yaml_get '.gameservers.ark.settings.server_password')
GAME_PORT=$(yaml_get '.gameservers.ark.ports.game')
QUERY_PORT=$(yaml_get '.gameservers.ark.ports.query')
RCON_PORT=$(yaml_get '.gameservers.ark.ports.rcon')

# Vérification du dossier d'installation
if [[ ! -d "$ARK_HOME" ]]; then
    error "Le dossier ARK n'existe pas : $ARK_HOME"
    exit 1 
fi

cd "$ARK_HOME"

log "Démarrage du serveur ARK ASA..."

# Construction de la ligne de commande ARK ASA
CMD="./ShooterGame/Binaries/Linux/ShooterGame \
$MAP?listen?SessionName=$SESSION_NAME?ServerPassword=$SERVER_PASSWORD?ServerAdminPassword=$ADMIN_PASSWORD \
-port=$GAME_PORT \
-queryport=$QUERY_PORT \
-RCONPort=$RCON_PORT \
-NoBattleEye \
-UseBattleEye \
-log"

# Affichage pour debug 
log "Commande exécutée :"
echo "$CMD"

# Exécution 
exec $CMD