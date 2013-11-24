#!/bin/bash

apt-get -yq install apache2-mpm-worker

a2enmod actions dir rewrite expires headers

a2dismod status cgid autoindex

###

GREPOUT=`grep "ServerName" /etc/apache2/httpd.conf`
if [ -z "$GREPOUT" ];
then
    echo "ServerName localhost" >> /etc/apache2/httpd.conf
fi

###

ln -s /etc/apache2/sites-available /etc/apache2/sa

ln -s /etc/apache2/sites-enabled /etc/apache2/se

ln -s /etc/apache2/mods-available /etc/apache2/ma

ln -s /etc/apache2/mods-enabled /etc/apache2/me

###

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

###

service apache2 restart

