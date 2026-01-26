#!/bin/bash

SERVICE="palworld.service"

#Vérifie si systemd pense que le service est actif
if systemctl is-active --quiet $SERVICE;then
    echo "Service actif."
else 
    echo "Service Inactif. Redémarrage..."
    sudo systemctl restart $SERVICE
    exit 0
fi

#Vérifie si le processus existe réellement
if grep -f PalServer > /dev/null; then
    echo "Processus présent."
else
    echo "Processus absent. Redémarrage..."
    sudo systemctl restart $SERVICE
    exit 0
fi

echo "Tout est OK"