#!/bin/bash
source "$(dirname "$0")/colors.sh"

log() {
    echo -e "${BLUE}[INFO]{RESET} $1"
}

success() {
    echo -e "${GREEN}[OK]{RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]{RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]{RESET} $1"
}