#!/bin/bash

# http://askubuntu.com/questions/109404/how-do-i-install-latest-php-in-supported-ubuntu-versions-like-5-4-x-in-ubuntu-1
add-apt-repository -y ppa:ondrej/php5

apt-get -yq update

apt-get -yq update

###

apt-get -yq install libapache2-mod-fastcgi php5-fpm php5

apt-get -yq install php-pear php5-cli php5-mysql php5-gd php5-imagick php5-curl php5-tidy php5-xmlrpc php5-mcrypt php5-sqlite php5-recode php5-pspell

apt-get -yq install php5-memcache memcached

a2enmod actions fastcgi alias

###

cat > /etc/apache2/conf.d/php5-fpm.conf << EOF
DirectoryIndex index.php index.html
<IfModule mod_fastcgi.c>
  AddHandler php5-fcgi .php
  Action php5-fcgi /php5-fcgi
  Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
  FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
</IfModule>
EOF

###

sed -e "s/;\?expose_php .*/expose_php \= Off/g" -i /etc/php5/fpm/php.ini

sed -e "s/^#\+/;/g" -i /etc/php5/fpm/conf.d/imagick.ini

sed -e "s/^#\+/;/g" -i /etc/php5/fpm/conf.d/mcrypt.ini

###

service php5-fpm restart

service apache2 restart

