#!/bin/bash
set -euo pipefail

# Chargement du COMMON
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"
source "$ROOT/../common/system.sh"

log "=== Initialition du serveur ARK ASA ==="

# Lecture du YAML
SERVICE_NAME=$(yaml_get '.gamservers.ark.service_name')
INSTALL_DIR=$(yaml_get '.gameservers.ark.install_dir')
GAME_PORT=$(yaml_get '.gameservers.ark.ports.game')

# Vérification root 
if [[ $EUID -ne 0 ]]; then
    error "Ce script doit être exécuté en root."
    exit 1
fi

#1. Installation
log "Étape 1/4 : Installation du serveur ARK..."
bash "$ROOT/install.sh"

#2. Mise à jour
log "Étape 2/4 : Mise à jour du serveur ARK..."
bash "$ROOT/update.sh"

#3. Génération du service systemd
log "Étape 3/4 : Génération du service ARK..."
bash "$ROOT/../common/generate_service.sh" ark

#4. Démarrage du service
log "Étape 4/4 : Démarrage du service ARK..."
service_restart "$SERVICE_NAME"

#5. Vérification du port
log "Vérification du port $GAME_PORT..."
sleep 5

if port_is_open "$GAME_PORT"; then
    success "Le serveur ARK ASA fonctionne correctement sur le port $GAME_PORT."
else
    warning "Le serveur ARK ne répond pas encore sur le port $GAME_PORT"
    warning "Il peut prendre 1 à 3 minutes pour démarrer complètement."
fi

success "Installation complète d'ARK ASA terminée."