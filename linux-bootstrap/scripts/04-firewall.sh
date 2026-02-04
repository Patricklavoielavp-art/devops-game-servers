#!/bin/bash
source ../config/firewall.env
ufw default deny incoming
ufw default allow outgoing

for port in $ALLOWED_TCP; do
    ufw allow $port/tcp
done

for port in $ALLOWED_UDP; do
    ufw allow $port/udp
done 

ufw --force enable