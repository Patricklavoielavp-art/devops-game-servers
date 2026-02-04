#!/bin/bash
set -e
source ../config/server.env

echo "📊 Installing monitoring stack: $MONITORING_STACK"

if [["$MONITORING_STACK" == "netdata" ]]; then

    echo "➡ Installing Netdata..."
    curl -s https://my-netdata.io/kickstart.sh | bash -s -- --stable-channel

    systemctl enable netdata
    systemctl start netdata

    echo "🌐 Netdata available on port 19999"
elif [[ "$MONITORING_STACK" == "prometheus" ]]; then

    echo "➡ Installing Prometheus node exporter..."
    apt install -y prometheus-node-exporter

    systemctl enable prometheus-node-exporter
    systemctl start prometheus-node-exporter

    echo "📈 Node exporter available on port 9100"
else
    echo " Unknown monitoring stack: $MONITORING_STACK"
    exit 1
fi