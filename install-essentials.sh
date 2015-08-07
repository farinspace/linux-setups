#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get -yq update

apt-get -yq upgrade

apt-get -yq install zip unzip expect locate ntp vim

# adds support for add-apt-repository
apt-get -yq install python-software-properties

apt-get -yq update

# set default editor as vim
update-alternatives --set editor /usr/bin/vim.basic

updatedb
