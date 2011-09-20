#!/bin/bash

###

echo -n "Short name? [e.g. /var/www/shortname] "
read SHORTNAME

if [ -z "$SHORTNAME" ];
then
    echo "Short name required"
    exit
fi

###

echo -n "Host? [e.g. www.example.com] "
read HOSTNAME

if [ -z "$HOSTNAME" ];
then
    echo "Host required"
    exit
fi

###

mkdir /var/www/$SHORTNAME

mkdir /var/www/$SHORTNAME/html

mkdir /var/www/$SHORTNAME/logs

echo '<?php phpinfo(); ?>' > /var/www/$SHORTNAME/html/index.php

cat > /etc/apache2/sites-available/$SHORTNAME << EOF
<VirtualHost *:80>
  ServerName $HOSTNAME
  ErrorLog /var/www/$SHORTNAME/logs/error.log
  CustomLog /var/www/$SHORTNAME/logs/access.log combined
  DocumentRoot /var/www/$SHORTNAME/html
  <Directory /var/www/$SHORTNAME/html/>
    Options FollowSymLinks ExecCGI
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>
</VirtualHost>
EOF

ln -s /etc/apache2/sites-available/$SHORTNAME /etc/apache2/sites-enabled/$SHORTNAME

WWWLOGS='/etc/logrotate.d/wwwlogs'

if [ ! -f $WWWLOGS ];
then
cat > $WWWLOGS << EOF
/var/www/*/logs/*.log {
	weekly
	missingok
	rotate 26
	compress
	delaycompress
	notifempty
	create 640 root adm
	sharedscripts
	postrotate
		if [ -f "\`. /etc/apache2/envvars ; echo \${APACHE_PID_FILE:-/var/run/apache2.pid}\`" ]; then
			/etc/init.d/apache2 reload > /dev/null
		fi
	endscript
}
EOF
fi

service apache2 reload
