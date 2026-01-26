#!/bin/bash

SERVER_DIR="/servers/palworld"

echo "=== LOG DU SERVEUR PALWORLD ==="
journalctl -u palworld.service -f