#!/usr/bin/env bash
set -e

echo "==== Installing Netdata ===="
bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
systemctl enable netdata
systemctl start netdata
echo "Monitoring available at http://<VM_IP>:19999"
