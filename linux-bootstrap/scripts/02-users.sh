#|/bin/bash
source ../config/server.env
# create admin user
id -u "$NEW_USER" &>/dev/null || useradd -m -s /bin/bash "$NEW_USER"
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$NEW_USER"
chmod 440 /etc/sudoers.d/90-$NEW_USER