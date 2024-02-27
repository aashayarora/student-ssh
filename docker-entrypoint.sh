#!/bin/bash
set -e

# Create the SSH user
chmod 644 /home/$SSH_USER
useradd -d /home/$SSH_USER -s /bin/bash $SSH_USER
echo "$SSH_USER:$(openssl rand -base64 32)" | chpasswd
chmod 755 /home/$SSH_USER

mkdir -p /home/$SSH_USER/.ssh
chmod 700 /home/$SSH_USER/.ssh
echo $SSH_PUB_KEY > /home/$SSH_USER/.ssh/authorized_keys
chmod 600 /home/$SSH_USER/.ssh/authorized_keys

cp /etc/skel/.bashrc /etc/skel/.profile /home/$SSH_USER

chown -R $SSH_USER:$SSH_USER /home/$SSH_USER

# sshd_config
sed -i "s/#Port 22/Port 9122/g" /etc/ssh/sshd_config
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config

# Start the SSH service
service ssh start

# Keep the container running
tail -f /dev/null