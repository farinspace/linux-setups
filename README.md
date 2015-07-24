## Ubuntu server setups

These are bash scripts to help setup and configure a fresh Ubuntu 14.04 LTS server install (primarily tested on Rackspace, but should work elsewhere as well).

```
sudo apt-get install git-core
git clone https://github.com/farinspace/linux-setups.git
```

Setup scripts should be run in the following order:

```
./install-essentials.sh
./secure-ssh.sh
./install-apache.sh
./install-php.sh
./install-mysql.sh
./install-postfix
./secure-iptables.sh
```

Add Apache virtual hosts with the following:

```
./add-apache-vhost.sh
```
