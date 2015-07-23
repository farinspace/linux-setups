#!/bin/bash

apt-get -yq update

apt-get -yq upgrade

apt-get -yq install zip unzip expect locate ntp

# adds support for add-apt-repository
apt-get -yq install python-software-properties

apt-get -yq update

updatedb
