#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "$(realpath "$0")")"
source "$(dirname "$0")/.../common/common.sh"
source "$ROOT/.env"

systemctl stop ark.service || true

sudo -u "$ARK_USER" "$STEAMCMD_BIN" +login anonymous \
    +force_install_dir "$ARK_HOME" \
    +app_update "$ARK_APP_ID" \
    +quit

systemctl start ark.service