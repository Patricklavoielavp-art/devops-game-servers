#!/bin/bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement des modules 
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"
source "$ROOT/../common/system.sh"

log "==== Initialisation du serveur Palworld ===="

# Lecture du YAML
SEVICE_NAME=$(yaml_get '.gameservers.palworld.service_name')
INSALL_DIR=$(yaml_get '.gameservers.palworld.install_dir')
GAME_PORT=$(yaml_get '.gameservers.palworld.ports.game')

# Vérification root
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être executé en root."
    exit 1
fi 

#1. Installation 
log "Étape 1/4 : Installation du serveur Palworld..."
bash "$ROOT/install.sh"

#2. Mise à jour
log "Étape 2/4 : Mise à jour du serveur Palworld..."
bash "$ROOT/update.sh"

#3. Génération du service systemd
log "Étape 3/4 : Génération du service systemd..."
bash "$ROOT/../common/generate_service.sh" palworld

#4. Démarrage du service 
log "Étape 4/4 : Démarrage du service Palword..."
service_restart "$SERVICE_NAME"

#5. Vérification du port
log "Vérification du port $GAME_PORT..."
sleep 5

if port_is_open "$GAME_PORT"; then
    success "Le serveur Palworld fonctionne correctement sur le port $GAME_PORT."
else 
    warning "Le serveur Palworld ne répond pas encore sur le port $GAME_PORT."
    warning "Il peut prendre 1 à 2 minutes pour démarrer complètement."
fi

success "Initialisation complète de Palworld terminée."