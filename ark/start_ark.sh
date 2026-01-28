#!/usr/bin/env bash
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

# Priorité ENV > YAML
ARK_HOME="${ARK_HOME:-$(yaml_get '.gameservers.ark.install_dir')}"
MAP="${ARK_MAP:-$(yaml_get '.gameservers.ark.settings.map')}"
SESSION_NAME="${ARK_SESSION_NAME:-$(yaml_get '.gameservers.ark.settings.session_name')}"
ADMIN_PASSWORD="${ARK_ADMIN_PASSWORD:-$(yaml_get '.gameservers.ark.settings.admin_password')}"
SERVER_PASSWORD="${ARK_SERVER_PASSWORD:-$(yaml_get '.gameservers.ark.settings.server_password')}"
GAME_PORT="${ARK_GAME_PORT:-$(yaml_get '.gameservers.ark.ports.game')}"
QUERY_PORT="${ARK_QUERY_PORT:-$(yaml_get '.gameservers.ark.ports.query')}"
RCON_PORT="${ARK_RCON_PORT:-$(yaml_get '.gameservers.ark.ports.rcon')}"

BIN="$ARK_HOME/ShooterGame/Binaries/Linux/ShooterGame"

if [[ ! -x "$BIN" ]]; then
    error "Binaire ARK introuvable : $BIN"
    exit 1
fi

log "Démarrage ARK Survival Ascended"

CMD=(
"$BIN"
"$MAP?listen?SessionName=$SESSION_NAME?ServerPassword=$SERVER_PASSWORD?ServerAdminPassword=$ADMIN_PASSWORD"
-port="$GAME_PORT"
-queryport="$QUERY_PORT"
-RCONPort="$RCON_PORT"
-NoBattleEye
-log
)

log "Commande ARK : ${CMD[*]}"
exec "${CMD[@]}"
