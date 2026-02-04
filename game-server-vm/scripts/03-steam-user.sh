#!/bin/bash
set -Eeuo pipefail

if id "$STEAM_USER" $>/dev/null; then
   echo "ℹ️  User '$STEAM_USER' already exists"
else 
   echo "👤 Creating user '$STEAM_USER'..."
   useradd \
     --create-home \
     --home-dir "$STEAM_HOME" \
     --shell /bin/bash \
     "$STEAM_USER"
fi

mkdir -p /opt/game-servers
chown -R steam:steam /opt/devops-game-servers/game-servers 
chmod 755 /opt/devops-game-servers/gameservers
