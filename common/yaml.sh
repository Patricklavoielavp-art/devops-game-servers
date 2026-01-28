#!/bin/bash

# Requires yq (v4)
require_yq() {
    if ! command -v yq &>/dev/null; then
        echo "yq n'est pas installé. Installation..."
        sudo apt install -y yq
    fi
}

yaml_get() {
    local path=$1
    yq "$path" config.yaml
}