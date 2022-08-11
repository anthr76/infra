#!/bin/bash

#TODO: maybe make this better in a lot of ways.
# or not..

for i in {1..3}
do
   echo -n "master-0"$i" "
   talosctl apply-config -n master-0"$i" -f clusterconfig/scr1-cluster-0-master-0"$i".scr1.rabbito.tech.yaml
done
for i in {1..9}
do
   echo -n "worker-0"$i" "
   talosctl apply-config -n worker-0"$i" -f clusterconfig/scr1-cluster-0-worker-0"$i".scr1.rabbito.tech.yaml
done
for i in {10..12}
do
   echo -n "worker-"$i" "
   talosctl apply-config -n worker-"$i" -f clusterconfig/scr1-cluster-0-worker-"$i".scr1.rabbito.tech.yaml
done
