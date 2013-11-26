#!/bin/bash

apt-get -yq install exim4 exim4-config

echo ""

echo "Run \"dpkg-reconfigure exim4-config\" to configure"

echo "Run \"vim /etc/exim4/update-exim4.conf.conf\" to check configuration"

echo "Run \"vim /etc/exim4/passwd.client\" to edit smarthost login"

echo "Run \"vim /etc/mailname\" to configure"

echo "Run \"update-exim4.conf\" to generate exim4 master configuration file"

echo "Run \"service exim4 restart\" to restart exim4"

echo ""

