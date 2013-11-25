#!/bin/bash

apt-get -yq install exim4 exim4-config

echo ""

echo "Run \"dpkg-reconfigure exim4-config\" to configure"

echo "Run \"vim /etc/exim4/passwd.client\" to edit smarthost login info"
