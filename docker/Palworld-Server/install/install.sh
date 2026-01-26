#!/bin/bash

set -e

SERVER_DIR="/servers/palworld"
STEAMCMD_DIR="/servers/steamcmd"

echo="[1/6] Installation des dépendences"
sudo apt update
sudo apt install -y lib32gcc-s1 lib32stdc++6 curl tar

echo "[2/6] Installation de SteamCMD"
mkdir -p $STEAMCMD_DIR
cd $STEAMCMD_DIR
curl -sql "https://steamcmd-a.akamaihd.net/client/installer/steamcm_linux.tar.gz" | tar zxvf -

echo "[3/6] Téléchargement du serveur Palworld"
mkdir -p $SERVER_DIR
$STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +app_update 2394010 validate \
    +quit

echo "[4/6] Copie du fichier configuration"
if[ -f "./config/DefaultPalWorldSettings.ini"]; then
    mkdir -p $SERVER_DIR/Pal/Saved/Config/LinuxServer
    cp ./config/DefaultPalWorldSettings.ini \
        $SERVER_DIR/Pal/Saved/Config/LunixServer/
else
    echo "Attention : Le fichier DefaultPalWorldSettings.ini est introuvable."
fi

echo "[5/6] Création du service systemd"
sudo tee /etc/systemd/system/palworld.service > /dev/null <<EOF
[Unit]
Description=Palworld Dedicate Server
After=network.target

[Service]
Type=simple
USER=$USER
WorkingDirectory=$SERVER_DIR
ExecStart=$SERVER_DIR/PalServer.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "[6/6] Activation du service"
sudo systemctl deamon-reload
sudo systemctl enable palworld.service
sudo systemctl start palorld.service

echo "Installation terminée"
echo "Serveur Palworld en cours d'éxécution"
