## Ubuntu Server Setups

These are bash scripts to help setup and configure a fresh Ubuntu 14.04 LTS server install (primarily tested on Rackspace, but should work elsewhere as well).

```
apt-get -y update
apt-get -y install git-core
git clone https://github.com/farinspace/linux-setups.git
cd linux-setups
```

Setup scripts should be run in the following order:

```
./install-essentials.sh
./secure-ssh.sh
./install-apache.sh
./install-php.sh
./install-mysql.sh
./install-postfix.sh
./install-sftp.sh
./secure-iptables.sh
```

Add Apache virtual hosts with the following:

```
./add-apache-vhost.sh
```

Add SFTP users with the following:

```
./add-sftp-user.sh
```
