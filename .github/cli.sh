#!/bin/bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

usage() {
    echo "Usage: $0 {install|update|backup|monitor|start|setup} {ark|palworld}"
    exit 1
}

[[ $# -ne 2 ]] && usage

ACTION=$1
GAME=$2

case "$GAME" in 
    ark)
        DIR="$ROOT/ark"
        ;;
    palworld)
        DIR="$ROOT/palworld"
        ;;
    *)
        echo "Jeu inconnu : $GAME "
        usage
        ;;
esac

case "$ACTION" in
    install)
        bash "$DIR/install.sh"
        ;;
    update)
        bash "$DIR/update.sh"
        ;;
    backup)
        bash "$DIR/backup.sh"
        ;;
    monitor)
        bash "$DIR/monitor.sh"
        ;;
    start)
        bash "$DIR/start_${GAME}.sh"
        ;;
    setup)
        bash "$DIR/setup.sh"
        ;;
    *)
        echo "Action inconnu : $ACTION"
        usage
        ;;
esac