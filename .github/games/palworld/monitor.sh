#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"

if ! "$ROOT/health-check.sh"; then
  echo "[!] Palworld seems down. Restarting..."
  systemctl restart palworld.service
fi