#!/bin/bash

###

if ! which expect &> /dev/null;
then
    echo "Unable to find command 'expect', run ./essentials.sh first"
    exit
fi;

###

echo -n "Username: "
read USERNAME

if [ -z "$USERNAME" ]
then
    echo "Username must not be empty"
    exit
fi

###

echo -n "Shell Password: "
read -s PASSWORD
echo ""

echo -n "Retype Shell Password: "
read -s PASSWORD2
echo ""

if [ "$PASSWORD" != "$PASSWORD2" ]
then
    echo "Shell Passwords do not match"
    exit
fi

###

echo -n "SSH Public Key (end input with ESC): "
read -d `echo -e "\e"` PUBLICKEY
echo ""

if [ -z "$PUBLICKEY" ]
then
    echo "Public Key must not be empty"
    exit
fi

###

echo -n "SSH Port [default=22]: "
read PORT

if [ -z "$PORT" ]
then
    PORT='22'
fi

###

useradd -s /bin/bash -m $USERNAME

# add user to sudo group (append)
usermod -a -G sudo $USERNAME

# add user password
expect << EOF
spawn passwd $USERNAME
expect "Enter new UNIX password:"
send "${PASSWORD}\r"
expect "Retype new UNIX password:"
send "${PASSWORD}\r"
expect eof;
EOF

###

mkdir /home/$USERNAME/.ssh

touch /home/$USERNAME/.ssh/authorized_keys

# remove newlines from public key
echo "ssh-rsa $PUBLICKEY" | sed ':a;N;$!ba;s/\n//g' >> /home/$USERNAME/.ssh/authorized_keys

###

# backup original config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sed -e "s/#\?Port .*/Port $PORT/g" -i /etc/ssh/sshd_config

sed -e "s/#\?RSAAuthentication .*/RSAAuthentication yes/g" -i /etc/ssh/sshd_config

sed -e "s/#\?PubkeyAuthentication .*/PubkeyAuthentication yes/g" -i /etc/ssh/sshd_config

sed -e "s/#\?PermitRootLogin .*/PermitRootLogin no/g" -i /etc/ssh/sshd_config

sed -e "s/#\?PasswordAuthentication .*/PasswordAuthentication no/g" -i /etc/ssh/sshd_config

# restart ssh
service ssh restart
