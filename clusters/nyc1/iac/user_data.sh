#!/bin/bash
cp /etc/sysconfig/network/ifcfg-eth0 /etc/sysconfig/network/ifcfg-eth1
wicked ifup eth1
echo 'NETCONFIG_DNS_STATIC_SERVERS="10.136.153.234 10.136.42.191"' >> /etc/sysconfig/network/config
echo 'NETCONFIG_DNS_STATIC_SEARCHLIST="k8s.rabbito.tech"' >> /etc/sysconfig/network/config
netconfig update -f
useradd -m localanthony
echo "localanthony ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/localanthony
mkdir -pm700 /home/localanthony/.ssh
cp /root/.ssh/authorized_keys /home/localanthony/.ssh/authorized_keys
chown localanthony:users -R /home/localanthony/.ssh
