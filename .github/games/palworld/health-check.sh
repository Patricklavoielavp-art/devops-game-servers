#!/bin/bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

PORT=8211

if nc -z localhost $PORT; then
    echo "healthy"
else
    echo "unhealthy"
fi
