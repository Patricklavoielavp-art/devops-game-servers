#!/usr/bin/env bash
set -e

echo "==== Preparing VM for Proxmox migration ===="

# Clean temporary files
rm -rf /tmp/* /var/tmp/*

# Ensure all services are enabled
systemctl enable gameserver@ark
systemctl enable gameserver@palworld
systemctl enable netdata
systemctl enable backup.timer

# Optional: convert disk to raw or qcow2 for Proxmox import
echo "Proxmox preparation done"
