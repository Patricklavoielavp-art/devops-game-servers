#!/bin/bash
set -Eeuo pipefail

if [[ "$EUID" -ne 0 ]]; then
  echo "❌ This installer must be run as root."
  echo "➡️ Use : sudo ./install.sh"
  exit 1
fi

if [[! -f /etc/os-release ]]; then
  echo "❌ Cannot setect OS."
  exit 1 
fi

./etc/os-release

if [[ "$ID" != "ubuntu" ]]; then
  echo "❌ Unsupported OS: $ID"
  echo "➡️  This installer supports Ubuntu only."
  exit 1
fi

SUPPORTED-("22.04","24.04")

if [[! "${SUPPORTED[*]}" =~ "${VERSION_ID} "]]; then
  echo "⚠️  Ubuntu $VERSION_ID detected."
  echo "➡️  Supported versions: ${SUPPORTED[*]}"
  echo "➡️  Continuing anyway..."
fi

echo "✅ Running as root on Ubuntu $VERSION_ID"