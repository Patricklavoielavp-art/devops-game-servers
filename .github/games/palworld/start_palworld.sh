#!/bin/bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

PAL_DIR="/opt/palworld"
PORT=8211
QUERY_PORT=27015
PLAYERS=32

cd "$PAL_DIR" || exit 1

"$PAL_DIR/PalServer.sh" \
  -port=$PORT \
  -queryport=$QUERY_PORT \
  -players=$PLAYERS \
  -log