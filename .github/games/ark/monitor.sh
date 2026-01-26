#!/usr/bin/env bash
# Chargement du COMMON
source "$ROOT/../COMMON/common.sh"
source "$ROOT/../COMMON/yaml.sh"

ROOT="$(dirname "$(realpath "$0")")"

"$ROOT/health-check.sh" || systemctl retart ar.service