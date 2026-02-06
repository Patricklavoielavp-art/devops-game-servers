#!/usr/bin/env bash
set -e

echo "==== Installing systemd services ===="

cp /opt/game-servers/systemd/gameserver@.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable gameserver@ark
systemctl enable gameserver@palworld
systemctl start gameserver@ark
systemctl start gameserver@palworld

echo "==== Services started ===="