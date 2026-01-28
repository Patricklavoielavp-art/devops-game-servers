#!/bin/bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement des modules
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"

# Lecture du YAML
PAL_HOME=$(yaml_get '.gameservers.palworld.install_dir')
GAME_PORT=$(yaml_get '.gameservers.palworld.ports.game')
QUERY_PORT=$(yaml_get '.gameservers.palworld.ports.query')
MAX_PLAYERS=$(yaml_get '.gameservers.palworld.settings.players')

# Vérification du dossier d'installation 
if [[ ! -d "$PAL_HOMEE" ]]; then
  error "Le dossier Palworld n'existe pas : $PAL_HOME"
  exit 1
fi

cd "$PAL_HOME"

log "Démarrage du serveur Palworld..."

# Construction de la commande Palworld
CMD="./PalServer.sh \
-port=$GAME_PORT \
-queryport=$QUERY_PORT \
-players=$MAX_PLAYERS \
-log"

# Affichage pour debug
log "Commande exécutée :"
echo "$CMD"

# Exécution
exec $CMD
