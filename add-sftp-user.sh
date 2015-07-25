#!/bin/bash

###

echo -n "Username: [e.g. john-sftp] "
read USERNAME

if [ -z "$USERNAME" ]
then
    echo "Username required."
    exit
fi

###

echo -n "SSH Public Key, e.g. \"ssh-rsa [PUBLICKEY]\" (end input with ESC):"
read -d `echo -e "\e"` PUBLICKEY
echo ""

if [ -z "$PUBLICKEY" ]
then
    echo "Public Key must not be empty"
    exit
fi

###

groupadd -f sftp

useradd -g sftp -s /sbin/nologin -m $USERNAME

###

mkdir /home/$USERNAME/.ssh

touch /home/$USERNAME/.ssh/authorized_keys

# remove newlines from public key
echo "$PUBLICKEY" | sed ':a;N;$!ba;s/\n//g' >> /home/$USERNAME/.ssh/authorized_keys
