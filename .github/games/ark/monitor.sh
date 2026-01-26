#!/usr/bin/env bash

ROOT="$(dirname "$(realpath "$0")")"
"$ROOT/health-check.sh" || systemctl retart ar.service