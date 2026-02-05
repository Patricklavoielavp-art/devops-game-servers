#!/bin/bash
set -e 

echo "🔐 Installing Vault Agent..."

apt update
apt install -y gnupg curl

curl -fsSl http://apt.releases.hashicorp.com/gpg | gpg --dearmor \
    -o /usr/share/keyrings/hashicorp.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] \
https://apt.releases.hashicorp.com $(lsb-release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list

apt update
apt install -y vault

mkdir -p /etc/vault.d/var/lib/vault

cat >/etc/vault.d/agent.hcl <<EOF
pid_file = "/var/run/vault-agent.pid"

vault {
  address = "$VAULT_ADDR"
}

auto_auth {
  method "$VAULT_AUTH_METHOD" {
    config = {
      role_name = "$VAULT_ROLE"
    }
  }
}

cache {
  use_auto_auth_token = true
}
EOF

systemctl enable vault 
systemctl start vault 

echo "✅ Vault Agent Installed"