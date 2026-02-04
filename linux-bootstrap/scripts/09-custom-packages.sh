#!/bin/bash
set -e

echo "🧰 Installing custom admin packages..."

apt install - y \
    git \
    vim \
    nano \
    htop \
    tmux \
    screen \
    tree \
    unzip \
    zip \
    jq \
    curl \
    wget \
    rsync \
    net-tools \
    ncdu \
    bash-completion

echo "✅ Custom packages installed"