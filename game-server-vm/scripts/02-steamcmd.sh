#!/bin/bash
set -Eeuo pipefail

echo "⏳ Installing SteamCMD..."

add-apt-repository multiverse -y 
dpkg --add-architecture i386
apt update
apt install -y steamcmd

mkdir -p /opt/steamcmd
ln -sf /usr/games/steamcmd /opt/steamcmd/steamcmd
