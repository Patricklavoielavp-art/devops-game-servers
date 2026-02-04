#!/bin/bash
set -e 

apt install -y apparmor apparmor-utils

systemctl enable apparmor
systemctl start apparmor

aa-enforce /etc/appramor.d/*