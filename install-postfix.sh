#!/bin/bash

###

echo -n "Domain name to use in outbound mail (e.g. example.org): "
read HOSTNAME

if [ -z "$HOSTNAME" ]
then
    echo "Domain must not be empty"
    exit
fi

###

echo -n "Email address to forward local mail sent to root/postmaster to (e.g. john@gmail.com): "
read EMAIL

###

export DEBIAN_FRONTEND=noninteractive

apt-get -y install mailutils

###

sed -e "s/#\?myhostname .*/myhostname $HOSTNAME/g" -i /etc/postfix/main.cf

sed -e "s/#\?mydestination .*/mydestination $HOSTNAME, localhost.localdomain, localhost/g" -i /etc/postfix/main.cf

sed -e "s/#\?inet_interfaces .*/inet_interfaces localhost/g" -i /etc/postfix/main.cf

###

echo "$HOSTNAME" > /etc/mailname

if [ -n "$EMAIL" ]
then
    echo "root: $EMAIL" >> /etc/aliases
    newaliases
fi

###

service postfix restart

echo ""
echo "Create a SPF DNS record, see \"http://www.openspf.org/SPF_Record_Syntax\" for details"
echo "Create a PTR reverse DNS record, see \"http://help.dnsmadeeasy.com/managed-dns/dns-record-types/ptr-record/\" for details"
