#!/bin/bash
set -e

apt install -y auditd audispd-plugins

cat >/etc/audit/rules.d/99-audit.rules <<EOF
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/sudoers -p wa -k sudo
-w /var/log/auth.log -p wa -k auth
-a always,exit -F arch=b64 -S execve -k exec
EOF

systemctl enable auditd
systemctl start auditd