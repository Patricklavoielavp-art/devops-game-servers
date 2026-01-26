#!/bin/bash

echo "==== STATUS PALWORLD ===="
systemctl is-active palworld.service

echo 
echo "=== PROCESSUS ==="
pgrep =fl PalServer || echo "Aucun processus PalServer trouvé"

echo 
echo "=== PORTS OUVERTS ==="
ss -tulpn | grep PalServer || echo "Aucun port ouvert par PalServer"