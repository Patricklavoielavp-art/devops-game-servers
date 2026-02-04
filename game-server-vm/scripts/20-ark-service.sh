#!/bin/bash
set -Eeuo pipefail

cp systemd/ark.service /etc/systemd/system/ark.service
systemctl daemon-reexec
systemtctl daemon-reload
systemtctl enable ark
systemtctl start ark
