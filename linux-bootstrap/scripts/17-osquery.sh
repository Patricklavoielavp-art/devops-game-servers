#!/bin/bash
set -e

echo "🕵️ Installing osquery"

apt update
apt install -y curl gnupg

curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg | gpg --dearmor \
  -o /usr/share/keyrings/osquery.gpg

echo "deb [signed-by=/usr/share/keyrings/osquery.gpg] \
https://pkg.osquery.io/deb deb main" \
  > /etc/apt/sources.list.d/osquery.list

apt update
apt install -y osquery

systemctl enable osqueryd
systemctl start osqueryd

echo "✅ osquery installed and running"
