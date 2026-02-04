#!/bin/bash
set -Eeuo pipefail

GAME=$1

if [[ -z "$GAME" ]]; then
  echo "Usage: $0 ark|palworld"
  exit 1
fi

echo "🔄 Starting live update for $GAME ..."

case "$GAME" in 
    ark)
      systemctl stop ark
      ;;
    palworld)
      systemctl stop palworld 
      ;;
esac

sleep 5

case "$GAME" in 
    ark)
        sudo -u steam /opt/steamcmd/steamcmd \
            +login anonymous \
            +force_install_dir /opt/devops-game-servers/game-servers/ark \
            +app_update 2430930 validate \
            +quit 
        systemctl start ark 
        ;;
    palworld)
        sudo -u steam /opt/steamcmd/steamcmd \
            +login anonymous \
            +force_install_dir /opt/devops-game-servers/game-servers/palworld \
            +app_update 2394010 validate \
            +quit 
        systemctl start palworld
        ;;
esac

echo "✅ $GAME updated and restarted"