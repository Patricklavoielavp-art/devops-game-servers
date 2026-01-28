#!/usr/bin/env bash
set -euo pipefail 

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Chargement des modules 
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"
source "$ROOT/../COMMON/network.sh"
source "$ROOT/../COMMON/system.sh"

# Lecture du YAML 
SERVICE_NAME=$(yaml_get '.gameservers.ark.service_name')
GAME_PORT=$(yaml_get 'gameservers.ark.ports.game')
MONITOR_ENABLED=$(yaml_get '.gameservers.ark.monitoring.enabled')
RESTART_ON_FAIL=$(yaml_get '.gameservers.ark.monitoring.restart_on_fail')
DICORD_WEBHOOK=$(yaml_get '.gameservers.ark.monitoring.discord_webhook' || echo "")

if [[ "$MONITOR_ENABLED" != "true" ]]; then
    warning "Monitoring ARK désactivé dans config.yaml"
    exit 0 
fi

log "Vérification du serveur ARK ASA..."

#1. Vérification du service systemd
if ! service_is_active "$SERVICE_NAME"; then
    error "Le service ARK ($SERVICE_NAME) est arrêté."

    if [[ "$RESTART_ON_FAIL" == "true" ]]; then
        log "Redémarrage automatique du service ..."
        service_restart "$SERVICE_NAME"
        success "Service redémarré."
    fi

    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -s -H "Content-Type: application/json" \
            -d "{\"content\": \"⚠️ ARK ASA est tombé. Redémarrage automatique effectué.\"}" \
            "$DISCORD_WEBHOOK" >/dev/bull || warning "Échec de l'envoi Discord."
    fi

    exit 1
fi 

#2. Vérification du port du serveur
if ! port_is_open "$GAME_PORT"; then
    error "Le port ARK ($GAME_PORT) ne répond pas."

    if [["$RESTART_ON_FAIL" == "true"]]; then
        log "Redémarrage automatique du service..."
        service_restart "$SERVICE_NAME"
        success "Service redémarré."
    fi
    
    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -s -H "Content-Type: application/json" \
            -d "{\"content\": \"⚠️ ARK ASA ne répond plus sur le port $GAME_PORT. Redémarrage automatique effectué.\"}" \
            "$DISCORD_WEBHOOK" >/dev/null || warning "Échec de l'envoi Discord."
    fi

    exit 1 
fi 

success "ARK ASA fonctionne normalement."