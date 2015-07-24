#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

###

add-apt-repository -y ppa:ondrej/php5-5.6

apt-get -yq update

###

apt-get -yq install libapache2-mod-fastcgi php5-fpm php5 php5-cli php5-mysql php5-gd php5-imagick php5-curl php5-tidy php5-xmlrpc php5-mcrypt php5-sqlite php5-recode php5-pspell php5-memcache memcached

a2enmod actions fastcgi alias

###

cat > /etc/apache2/conf-available/php5-fpm.conf << EOF
DirectoryIndex index.php index.html
<IfModule mod_fastcgi.c>
  AddHandler php5-fcgi .php
  Action php5-fcgi /php5-fcgi
  Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
  FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
  <Directory /usr/lib/cgi-bin>
    Require all granted
  </Directory>
</IfModule>
EOF

ln -s /etc/apache2/conf-available/php5-fpm.conf /etc/apache2/conf-enabled/php5-fpm.conf

###

sed -e "s/;\?expose_php .*/expose_php \= Off/g" -i /etc/php5/fpm/php.ini

###

service php5-fpm restart

service apache2 restart

echo ""
echo "Run \"cp test-php.php /var/www/html/test-php.php\" to test PHP"
echo "Run \"cp test-mail.php /var/www/html/test-mail.php\" to test Mail"
echo ""
