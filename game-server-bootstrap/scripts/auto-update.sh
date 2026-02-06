#!/usr/bin/env bash
set -e

echo "==== Configuring automatic server updates ===="

(crontab -l 2>/dev/null; echo "0 5 * * * /opt/game-servers/scripts/install-server.sh 376030 /opt/game-servers/ark") | crontab -
(crontab -l 2>/dev/null; echo "0 5 * * * /opt/game-servers/scripts/install-server.sh 2394010 /opt/game-servers/palworld") | crontab -

echo "Auto-update scheduled daily at 5am"
