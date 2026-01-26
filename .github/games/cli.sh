#!/bin/bash
source "./COMMON/common.sh"
source "./COMMON/yaml.sh"

Action=$1
GAME=$2

case"$Action" in
    install)
        bash "$GAME/install.sh"
        ;;
    update)
        bash "$GAME/update.sh"
        ;;
    backup)
        bash "$GAME/backup.sh"
        ;;
    monitor)
        bash "$GAME/monitor.sh"
        ;;
    status)
        service_name=$(yaml_get ".gameservers.$GAME.service_name")
        service_status "$service_name"
        ;;
    *)
        echo "Usage : ./cli.sh {install|update|backup|monitor|status} {ark|palworld|fs25}"
        ;;
esac
