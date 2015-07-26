#!/bin/bash

###

echo -n "SSH Port [default=22]: "
read PORT

if [ -z "$PORT" ]
then
    PORT='22'
fi

###

TESTRULES='/etc/iptables.test.rules'

rm -R -f $TESTRULES

cat > $TESTRULES << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport $PORT -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
# https
#-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# svn
#-A INPUT -p tcp -m tcp --dport 3690 -j ACCEPT
# ftp
#-A INPUT -p tcp --dport 21 -m state --state ESTABLISHED,NEW -j ACCEPT
#-A INPUT -p tcp --dport 20 -m state --state ESTABLISHED -j ACCEPT
# see notes: http://serverfault.com/questions/234674/setting-up-linux-iptables-for-ftp-pasv-mode-connections
#-A INPUT -p tcp --dport 50000:60000 -m state --state RELATED,ESTABLISHED,NEW -j ACCEPT
# mysql pinhole
#-A INPUT -p tcp -m tcp --dport 3306 -s 127.0.0.1 -j ACCEPT
# ntp
-A INPUT -p udp -m udp --dport 123 -j ACCEPT
-A OUTPUT -p udp -m udp --sport 123 -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -j DROP
-A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -m state --state RELATED,ESTABLISHED,NEW -j ACCEPT
COMMIT
EOF

iptables-restore < $TESTRULES

iptables-save > /etc/iptables.up.rules

###

GREPOUT=`grep "pre-up" /etc/network/interfaces`

if [ -z "$GREPOUT" ]
then
    # backup original config file
    cp /etc/network/interfaces /etc/network/interfaces.bak
    sed -e "s/iface lo inet loopback/iface lo inet loopback\npre-up iptables-restore < \/etc\/iptables.up.rules/g" -i /etc/network/interfaces
fi

iptables -L

echo ""
echo "Use \"vim $TESTRULES\" to edit rules"
echo "Use \"iptables-restore < $TESTRULES\" to enable and test the rules"
echo "Use \"iptables-save > /etc/iptables.up.rules\" to save the rules"
echo ""
