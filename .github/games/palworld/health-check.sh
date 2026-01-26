#!/usr/bin/env bash
set -euo pipefail

EXPECTED_PORT="$PAL_PORT"

PORT=$(ss -tulpn | grep PalServer | awk '{print $5}' | cut -d: -f2 || true)

if [[ "$PORT" == "$EXPECTED_PORT" ]]; then
  echo "OK"
  exit 0
else
  echo "DOWN"
  exit 1
fi