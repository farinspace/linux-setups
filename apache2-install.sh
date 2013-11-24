#!/bin/bash

###

apt-get -yq install apache2-mpm-worker

a2enmod actions

a2enmod dir

a2enmod rewrite

a2enmod expires

a2enmod headers

a2dismod status

a2dismod cgid

a2dismod autoindex

GREPOUT=`grep "ServerName" /etc/apache2/httpd.conf`
if [ -z "$GREPOUT" ];
then
    echo "ServerName localhost" >> /etc/apache2/httpd.conf
fi

ln -s /etc/apache2/sites-available /etc/apache2/sa

ln -s /etc/apache2/sites-enabled /etc/apache2/se

ln -s /etc/apache2/mods-available /etc/apache2/ma

ln -s /etc/apache2/mods-enabled /etc/apache2/me

service apache2 restart
