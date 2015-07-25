#!/bin/bash

groupadd -f sftp

sed -e "s/#\?Subsystem sftp .*/Subsystem sftp internal-sftp/g" -i /etc/ssh/sshd_config

echo "" >> /etc/ssh/sshd_config
echo "Match Group sftp" >> /etc/ssh/sshd_config
echo "  ChrootDirectory /var/www" >> /etc/ssh/sshd_config
echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
echo "  AllowTCPForwarding no" >> /etc/ssh/sshd_config
echo "  X11Forwarding no" >> /etc/ssh/sshd_config
echo "" >> /etc/ssh/sshd_config

service ssh restart

echo "Use \"./add-sftp-user.sh\" to create a SFTP user"
