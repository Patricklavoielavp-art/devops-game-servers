#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )/logging.sh"

servie_start() {
    sudo systemctl start "$1"
    success "Service $1 démarré"
}

servie_stop() {
    sudo systemctl stop "$1"
    success "Service $1 arrêté"
}

servie_restart() {
    sudo systemctl restart "$1"
    success "Service $1 redémarré"
}

service_status() {
    sudo systemctl status "$1" --no-pager
}

service_enable() {
    sudo systemctl enable "$1"
    success "Service $1 activé au démarrage"
}