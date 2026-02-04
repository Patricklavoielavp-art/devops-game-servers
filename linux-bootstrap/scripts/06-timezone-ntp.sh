#!/bin/bash
source ../config/server.env

timedatectl set-timezone "$TIMEZONE"
apt install -y chrony
systemctl enable chrony
systemctl restart chrony
