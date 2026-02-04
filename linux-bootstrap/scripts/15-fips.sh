#!/bin/bash
set -e 

echo "🔐 Enabling FIPS mode"

if ! grep -q "fips=1" /proc/cmdline; then 
    echo "📦 Installing FIPS packages"
    apt update 
    apt install -y ubuntu-advantage-tools

    ua enable fips || {
        echo "❌ FIPS enable failed (subscription required)"
        exit 1
    }

    echo "⚠️ FIPS enabled - reboot REQUIRED"
else
    echo "✅ FIPS already active"
fi