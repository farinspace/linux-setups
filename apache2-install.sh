#!/bin/bash

###

echo "" >> /etc/apt/sources.list

echo "deb http://archive.ubuntu.com/ubuntu/ lucid main restricted multiverse" >> /etc/apt/sources.list

echo "deb-src http://archive.ubuntu.com/ubuntu lucid main restricted multiverse" >> /etc/apt/sources.list

apt-get -yq update

apt-get -yq update

apt-get -yq install apache2-mpm-worker libapache2-mod-fastcgi

a2enmod actions

a2enmod dir

a2enmod rewrite

a2enmod expires

a2enmod headers

a2dismod status

a2dismod cgid

a2dismod autoindex

ln -s /etc/apache2/sites-available /etc/apache2/sa

ln -s /etc/apache2/sites-enabled /etc/apache2/se

ln -s /etc/apache2/mods-available /etc/apache2/ma

ln -s /etc/apache2/mods-enabled /etc/apache2/me

service apache2 restart
