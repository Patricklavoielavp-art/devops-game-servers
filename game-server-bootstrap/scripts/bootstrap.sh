#!/usr/bin/env bash
set -e

echo "==== Starting full Pro-ready game server bootstrap ===="

# Install SteamCMD
bash /opt/game-servers/scripts/install-steamcmd.sh

# Install servers
bash /opt/game-servers/scripts/install-server.sh 376030 /opt/game-servers/ark
bash /opt/game-servers/scripts/install-server.sh 2394010 /opt/game-servers/palworld

# Install services
bash /opt/game-servers/scripts/install-services.sh

# CPU tuning
bash /opt/game-servers/scripts/cpu-tuning.sh

# Firewall rules
bash /opt/game-servers/scripts/firewall.sh

# Monitoring
bash /opt/game-servers/scripts/install-monitoring.sh

# Backup
systemctl enable backup.timer
systemctl start backup.timer

# Auto-update
bash /opt/game-servers/scripts/auto-update.sh

# Pro-ready prep
bash /opt/game-servers/scripts/pro-ready.sh

echo "==== Bootstrap complete ===="
echo "Check servers: systemctl status gameserver@ark / systemctl status gameserver@palworld"
echo "Monitoring: http://<VM_IP>:19999"
