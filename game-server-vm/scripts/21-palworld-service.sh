#!/bin/bash
set -Eeuo pipefail

cp systemd/palworld.service /etc/systemd/system/palworld.service
systemctl daemon-reexec
systemtctl daemon-reload
systemtctl enable palworld
systemtctl start palworld

