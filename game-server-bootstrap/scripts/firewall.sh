#!/usr/bin/env bash
set -e

echo "==== Configuring UFW Firewall ===="

sudo ufw allow 7777/tcp       # Ark Game Port
sudo ufw allow 27015/tcp      # Ark Query Port
sudo ufw allow 7778/udp       # Ark RCON/UDP
sudo ufw allow 7777-7780/udp  # Palworld
sudo ufw enable

echo "Firewall rules applied"
