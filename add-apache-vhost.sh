#!/bin/bash

###

echo -n "Short name? (e.g. /var/www/shortname) "
read SHORTNAME

if [ -z "$SHORTNAME" ];
then
    echo "Short name required."
    exit
fi

###

echo -n "Host? (e.g. www.example.com) "
read HOSTNAME

if [ -z "$HOSTNAME" ];
then
    echo "Host required."
    exit
fi

###

mkdir -p /var/www/$SHORTNAME
mkdir -p /var/www/$SHORTNAME/html
mkdir -p /var/www/$SHORTNAME/logs

cat > /etc/apache2/sites-available/${SHORTNAME}.conf << EOF
<VirtualHost *:80>
  ServerName $HOSTNAME
  ErrorLog /var/www/$SHORTNAME/logs/error.log
  CustomLog /var/www/$SHORTNAME/logs/access.log combined
  DocumentRoot /var/www/$SHORTNAME/html
  <Directory /var/www/$SHORTNAME/html/>
    Options FollowSymLinks ExecCGI
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
EOF

ln -s /etc/apache2/sites-available/${SHORTNAME}.conf /etc/apache2/sites-enabled/${SHORTNAME}.conf

service apache2 reload

chown -R www-data:www-data /var/www/$SHORTNAME

echo ""
echo "Use \"vim /etc/apache2/sites-enabled/${SHORTNAME}.conf\" to edit vhost"
echo ""
