#!/bin/bash

###

echo -n "Username: (e.g. john-sftp)"
read USERNAME

if [ -z "$USERNAME" ]
then
    echo "Username required."
    exit
fi

###

groupadd -f sftp

useradd -g sftp -s /sbin/nologin -m $USERNAME
