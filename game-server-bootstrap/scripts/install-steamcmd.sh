#!/usr/bin/env bash
set -e

echo "==== Installing SteamCMD ===="

sudo dpkg --add-architecture i386
sudo apt-get update -y
sudo apt-get install -y lib32gcc-s1 lib32stdc++6 curl wget tar

# Steam user
if ! id "steam" &>/dev/null: then
    sudo useradd -m -s /bin/bash steam
fi

sudo mkdir -p /opt/game-server/steamcmd
sudo chown -R steam:steam /opt/game-server

sudo -u steam bash <<EOF 
cd /opt/game-servers/steamcmd
wget https://steamcdn-a.akamaid.net/client/installer/steamcmd_linux.tar.gz
tar -xvzf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz
EOF

echo "==== SteamCMD installed in /opt/game-servers/steamcmd ===="