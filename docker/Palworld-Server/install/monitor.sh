#!bin/bash

SERVER_DIR="/servers/palworld"

echo "==== ÉTAT DU SERVICE ==="
systemctl status palworld.servce --no-pager

echo
echo "=== PROCESSUS PALWORLD ==="
ps aux | grep PalServer | grep -v grep

echo
echo "=== UTILISATION CPU/RAM ==="
top -b n 1 | head -n 20

echo
echo "=== TAILLE DU MONDE ==="
du -sh $SERVER_DIR/Pal/Saved