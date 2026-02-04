#!/bin/bach
set -e

echo "🐳 Installing Docker..."

# Remove old versions
apt remove -y docker-engine docker.io containerd runc || true

# Dependancies 
mkdir -p /etc/apt/keyrings
curl -fsSl https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyring/docker.gpg

# Docker repo
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Enable service
systemctl enable docker
systemctl start docker

# Allow non-root usage
if id "$NEW_USER" $>/dev/null; then
    usermod -aG docker "$NEW_USER"
fi

echo "✅ Docker installed"
echo "ℹ️ Log out/in for docker group to apply"