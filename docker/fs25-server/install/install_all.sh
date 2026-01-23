#!/bin/bach
#
# install_all.sh
# Script d'installation complet pour un serveur FS25 sous linux ubuntu
# Auteur : Patrick Lavoie

set -e

### --- VARIABLES -------------------------------------------------------------------------------------------

USER_NAME="gameserver"
SERVER_DIR="/home/$USER_NAME/servers/fs25"
STEAMCMD_DIR="/home/$USER_NAME/steamcmd"
APP_ID_FS25="3026720" # Remplacer par l'ID officiel FS25 Dedicated Server

### --- FONCTIONS --------------------------------------------------------------------------------------------

create_user() {
    if id "$USER_NAME" >/dev/null 2>&1; then
        echo "[INFO] L'utilisateur $USER_NAME existe déjà"
    else 
        echo "[INFO] Création de l'utilisateur $USER_NAME ..."
        sudo adduser --disabled-password --gecos "" "$USER_NAME"
    fi
}

install_dependencies() {
    echo "[INFO] Mise à jour du système"
    sudo apt update -y
    sudo apt upgrade -y

    echo "[INFO] Installation des dépendances ..."
    sudo apt install -y steamcmd curl wget tar unzip ufw
}

prepare_directories() {
    echo "[INFO] Création des dossiers nécessaires ..."
    sudo -u "$USER_NAME" mkdir -p "$SERVER_DIR"
    sudo -u "$USER_NAME" mkdir -p "$STEAMCMD_DIR"
}

install_steamcmd() {
    echo "[INFO] Installation de SteamCMD ..."
    sudo apt install -y steamcmd
}

install_fs25() {
    echo "[INFO] Installation du serveur FS25 via SteamCMD ..."
    sudo -u "$USER_NAME" steamcmd +login anonymous \
        +force_install_dir "$SERVER_DIR" \
        +app_update "$APP_ID_FS25" validate \
        +quit
}

configure_permissions() {
    echo "[INFO] Configuration des permissions ..."
    sudo chown -R "$USER_NAME":"$USER_NAME" /home/"$USER_NAME"
}

configure_firewall() {
    echo "[INFO] Ouverture des ports FS25"
    sudo ufw allow 10823/tcp
    sudo ufw allow 10823/udp
}

install_systemd_service() {
    echo "[INFO] Installation du service systemd FS25 ..."

    SERVICE_FILE="/etc/systemd/system/fs25.service"

    sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=FS25 Dedicated Server
After=network.target

[Service]
User=$USER_NAME
WorkingDirectory=$SERVER_DIR
ExecStart=$SERVER_DIR/dedicatedServer
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl enable fs25
}

## --- EXECUTION -----------------------------------------------------------------------------------------

echo "========================================================================="
echo " INSTALLATION COMPLETE DU SERVEUR FS25
echo "========================================================================="

create_user
intall_dependencies
prepare_directories
intall_steamcmd
install_fs25
configure_permissions
configure_firewall
install_systemd_service

echo "========================================================================="
echo " INSTALLATION TEMINEE !:
echo " Lance le serveur avec : sudo systemctl start fs25"
echo "========================================================================="