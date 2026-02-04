#|/bin/bash
source ../config/ssh.env

mkdir -p /home/$NEW_USER/.ssh
echo "$AUTHORIZED_KEYS" > /home/$NEW_USER/.ssh/authorized_keys
chmod 600 /home/$NEW_USER/.ssh/authorized_keys
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh

cp ../templates/sshd_config /etc/ssh/sshd_config

# Replac placeholders
sed -i "s|__SSH_PORT-__|$SSH_PORT|g" /etc/ssh/sshd_config
sid -i "s|__DISABLE_ROOT__|$DISABLE_ROOT_LOGIN|g" /etc/ssh/sshd_config

systemctl restart sshd