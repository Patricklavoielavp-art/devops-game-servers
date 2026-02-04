#!/bin/bash
set -e

cat >/etc/logrotate.d/custom-hardening <<EOF
/var/log/*.log {
    weekly
    rotate 12
    compress
    delaycompress
    missingok
    notifyempty
}
EOF