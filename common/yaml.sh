#!/bin/bash
# yaml.sh - lecture et écriture simple dans config.yaml avec yq (sans guillemets)

# --- Vérifie la présence de yq ---
require_yq() {
    if ! command -v yq &>/dev/null; then
        echo "yq n'est pas installé. Installation..."
        sudo apt update
        sudo apt install -y yq
    fi
}

# --- Lit une valeur dans config.yaml ---
# Usage: yaml_get ".service_name"
yaml_get() {
    local path=$1
    if [[ ! -f "config.yaml" ]]; then
        echo "Erreur : config.yaml introuvable"
        return 1
    fi
    # -r pour raw output → pas de guillemets
    yq e -r "$path" config.yaml
}

# --- Écrit ou met à jour une valeur dans config.yaml ---
# Usage: yaml_set ".service_name" "ark"
yaml_set() {
    local path=$1
    local value=$2
    if [[ ! -f "config.yaml" ]]; then
        echo "Erreur : config.yaml introuvable"
        return 1
    fi
    yq e -i "$path = \"$value\"" config.yaml
}

# --- Exemple d'utilisation ---
# require_yq
# echo "Service: $(yaml_get '.service_name')"  # renverra ark sans ""
# yaml_set '.service_name' 'ark'
