#!/bin/bash
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )")/logging.sh"

check_port() {
    local port=$1
    if nc -z localhost "$port";then
        succes "Port $port ouvert"
        return 0
    else 
        warn "Port $port fermé"
        return 1
    fi
}