#!/bin/bash
set -e 

apt install -y unattended-upgrades apt-listchanges

dpkg-reconfigure -f noninreractive unattended-upgrades

cat >/etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrades "1";
EOF

