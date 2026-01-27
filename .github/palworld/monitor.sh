#!/bin/bash
set -euo pipefail 

ROOT="$(dirname "$(realpath "$0")")"

#Chargement de modules 
source "$ROOT/../common/common.sh"
source "$ROOT/../common/yaml.sh"
source "$ROOT/../common/network.sh"
source "$ROOT/../common/system.sh"

# Lecture du YAML
SERVIE_NAME=$(yaml_get '.gameservers.palworld.service_name')
GAME_PORT=$(yaml_get '.gameservers.palworld.ports.game')
MONITOR_ENABLED=$(yaml_get '.gameservers.palworld.monitoring.enabled')
RESTART_ON_FAIL=$(yaml_get '.gameservers.palworld.monitoring.restart_on_fail')
DISCORD_WEBHOOK=$(yaml_get '.gameservers.palworld.monitoring.discord_webhook')

if [[ "$MONITOR_ENABLED" != "true"]]; then
    warning "Monitoring Palworld désactivé dans config.yaml"
    exit 0
fi

log "Vérification du serveur Palworld..."

# 1. Vérification du service systemd
if ! service_is_active "$SERVICE_NAME"; then
    error "Le service Palworld ($SERVICE_NAME) est arrêté."

    if [[ "$RESTART_ON_FAIL" == "true" ]]; then
        log "Redémarrage automatique du service…"
        service_restart "$SERVICE_NAME"
        success "Service redémarré."
    fi

    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -s -H "Content-Type: application/json" \
            -d "{\"content\": \"⚠️ Palworld est tombé. Redémarrage automatique effectué.\"}" \
            "$DISCORD_WEBHOOK" >/dev/null || warning "Échec de l'envoi Discord."
    fi

    exit 1
fi

# 2. Vérification du port du serveur
if ! port_is_open "$GAME_PORT"; then
    error "Le port Palworld ($GAME_PORT) ne répond pas."

    if [[ "$RESTART_ON_FAIL" == "true" ]]; then
        log "Redémarrage automatique du service…"
        service_restart "$SERVICE_NAME"
        success "Service redémarré."
    fi

    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -s -H "Content-Type: application/json" \
            -d "{\"content\": \"⚠️ Palworld ne répond plus sur le port $GAME_PORT. Redémarrage automatique effectué.\"}" \
            "$DISCORD_WEBHOOK" >/dev/null || warning "Échec de l'envoi Discord."
    fi

    exit 1
fi

success "Palworld fonctionne normalement."
