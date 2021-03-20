#!/bin/bash
cp /etc/sysconfig/network/ifcfg-eth0 /etc/sysconfig/network/ifcfg-eth1
wicked ifup eth1
useradd -m localanthony
echo "localanthony ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/localanthony
mkdir -pm700 /home/localanthony/.ssh
cp /root/.ssh/authorized_keys /home/localanthony/.ssh/authorized_keys
chown localanthony:users -R /home/localanthony/.ssh
