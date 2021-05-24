#!/bin/sh
# This script is executed at boot time after VyOS configuration is fully applied.
# Any modifications required to work around unfixed bugs
# or use services not available through the VyOS CLI system can be placed here.

# CoreDNS workaround until podman is fully supported on CLI

/usr/bin/podman container run --name coredns --volume /etc/hosts:/etc/hosts:ro --volume /config/user-data/Corefile:/etc/Corefile:ro --detach=True --network host --restart=always docker.io/coredns/coredns:1.8.3 -conf /etc/Corefile

/usr/bin/podman generate systemd --new --name coredns > /etc/systemd/system/container-coredns.service

/usr/bin/systemctl enable container-coredns.service
