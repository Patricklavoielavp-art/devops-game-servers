#!/usr/bin/env bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"


case "$1" in
  start) systemctl start palworld.service ;;
  stop) systemctl stop palworld.service ;;
  restart) systemctl restart palworld.service ;;
  status) systemctl status palworld.service ;;
  logs) journalctl -u palworld.service -f ;;
  *) echo "Usage: $0 {start|stop|restart|status|logs}" ;;
esac