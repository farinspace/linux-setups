#!/bin/bash

###

echo -n "SSH Port [default=22]: "
read PORT

if [ -z "$PORT" ]
then
    PORT='22'
fi

###

echo -n "Pasv FTP Port Range [default=50000:60000]: "
read PORTRANGE

if [ -z "$PORTRANGE" ]
then
    PORTRANGE='50000:60000'
fi

###

echo -n "IP Address (MySQL port access) [default=127.0.0.1]: "
read MYIP

if [ -z "$MYIP" ]
then
    MYIP='127.0.0.1'
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
#-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
#-A INPUT -p tcp -m tcp --dport 3690 -j ACCEPT
-A INPUT -p tcp --dport 21 -m state --state ESTABLISHED,NEW -j ACCEPT
-A INPUT -p tcp --dport 20 -m state --state ESTABLISHED -j ACCEPT
# see notes: http://serverfault.com/questions/234674/setting-up-linux-iptables-for-ftp-pasv-mode-connections
-A INPUT -p tcp --dport $PORTRANGE -m state --state RELATED,ESTABLISHED,NEW -j ACCEPT
-A INPUT -p tcp -m tcp --dport 3306 -s $MYIP -j ACCEPT
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
