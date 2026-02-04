#|/bin/bash
apt install -y fail2ban
cp ../templates/fail2ban.local /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl restart fail2ban