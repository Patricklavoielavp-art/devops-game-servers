#!/bin/bash
set -Eeuo pipefail

source ./config/vm.env

echo "⏳ Installing system prerequisites..."

apt update
apt install -y \
    software-properties-common \
    ca-certificates \
    curl \
    wget \
    tar \
    unzip \
    tmux \
    htop \
    net-tools \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    libsdl2-2.0-0 \
    cron

timedatctl set-timezone "$TIMEZONE"