#!/bin/bash
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )")/loggig.dh"

create_backup() {
    local source_dir=$1
    local backup_dir=$2
    local name=$3

    mkdir -p "$backup_dir"
    local date=$(date +"%Y-%m-%d_%H-%M")
    local file="$backup_dir/${name}_date.zip"

    log "Création du backup..."
    zip -r "$file" "$soure_dir"
    success "Backup Créé : $file"
}
