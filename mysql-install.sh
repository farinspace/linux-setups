#!/bin/bash

###

if ! which expect &> /dev/null;
then
    echo "Unable to find command 'expect', run ./essentials.sh first"
    exit
fi;

###

echo -n "MySQL \"root\" user password (leave blank for none): "
read -s MYSQLPASSWORD
echo ""

if [ ! -z "$MYSQLPASSWORD" ]
then
	echo -n "Retype MySQL \"root\" user password: "
	read -s MYSQLPASSWORD2
	echo ""

	if [ "$MYSQLPASSWORD" != "$MYSQLPASSWORD2" ]
	then
		echo "MySQL \"root\" user passwords do not match"
		exit
	fi
fi

###

expect << EOF
spawn apt-get -yq install mysql-server
expect "New password for the MySQL \"root\" user:"
send "${MYSQLPASSWORD}\r"
expect "Repeat password for the MySQL \"root\" user:"
send "${MYSQLPASSWORD}\r"
expect eof;
EOF

apt-get -yq install mysql-client

sed -e "s/^bind-address/#bind-address/g" -i /etc/mysql/my.cnf

sleep 2

service mysql restart
