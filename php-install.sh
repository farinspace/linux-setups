#!/bin/bash

###

if ! which expect &> /dev/null;
then
    echo "Unable to find command 'expect', run ./essentials.sh first"
    exit
fi;

###

echo -n "Web user account [default=www-data]: "
read USERNAME

if [ -z "$USERNAME" ]
then
    USERNAME='www-data'
fi

###

if [ "$USERNAME" != "www-data" ]
then
	echo -n "Web user account password (leave blank for none): "
	read -s PASSWORD
	echo ""

	if [ ! -z "$PASSWORD" ]
	then
		echo -n "Retype web user account password: "
		read -s PASSWORD2
		echo ""

		if [ "$PASSWORD" != "$PASSWORD2" ]
		then
			echo "Web user account passwords do not match"
			exit
		fi
	fi

	###

	useradd --home /var/www -M $USERNAME

	if [ ! -z "$PASSWORD" ]
	then

# add user password
expect << EOF
spawn passwd $USERNAME
expect "Enter new UNIX password:"
send "${PASSWORD}\r" 
expect "Retype new UNIX password:"
send "${PASSWORD}\r"
expect eof;
EOF

	fi
fi

###

add-apt-repository ppa:brianmercer/php

apt-get -yq update

apt-get -yq update

apt-get -yq install php5-fpm

###

sed -e "s/;\?expose_php .*/expose_php \= Off/g" -i /etc/php5/fpm/php.ini

###

sleep 2

###

mkdir /var/www/conf

mkdir /var/www/logs

mkdir /var/www/temp

###

FPMCONF='/etc/php5/fpm/php5-fpm.conf'

mv $FPMCONF "${FPMCONF}.bak"

cat > $FPMCONF << EOF
; global options
[global]
pid = /var/run/php5-fpm.pid
error_log = /var/log/php5-fpm.log

; default pool
[default]
listen = /etc/php5/fpm/php5-fpm.sock
listen.owner = $USERNAME
listen.group = $USERNAME
user = $USERNAME
group = $USERNAME
pm = dynamic
pm.max_children = 3
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 3
pm.max_requests = 500
slowlog = /var/log/php5-fpm.slow.log
env[HOSTNAME] = \$HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /var/www/temp
env[TMPDIR] = /var/www/temp
env[TEMP] = /var/www/temp

; pool options
; include=/var/www/*/conf/fpm-pool.conf
EOF

###

# not installing php5-cgi, will auto install apache
apt-get -yq install php-pear php5-cgi php5-cli php5-mysql php5-gd php5-imagick php5-curl php5-tidy php5-xmlrpc php5-mcrypt

apt-get -yq install php5-memcache

apt-get -yq install memcached

sed -e "s/^#\+/;/g" -i /etc/php5/fpm/conf.d/imagick.ini

sed -e "s/^#\+/;/g" -i /etc/php5/fpm/conf.d/mcrypt.ini

###

service php5-fpm start

chown -R $USERNAME:$USERNAME /var/www
