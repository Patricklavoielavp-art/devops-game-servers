#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../common/common.sh"

PORT=$(s -tulpn | grep ShooterGameServer | awk '{print $5}' | cut -d: -f2)

if [["$PORT" == "$ARK_PORT]]; then
    echo "OK"
    exit 0
else 
    echo "DOWN"
    exit 1
fi
