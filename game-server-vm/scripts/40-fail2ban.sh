#!/bin/bash
ste -Eeuo pipefail

echo "🛡️  Installing Fail2Ban..."

apt install -y fail2ban

cat >/etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
port = ssh
EOF

systemctl enable fail2ban 
systemctl restart fail2ban 

