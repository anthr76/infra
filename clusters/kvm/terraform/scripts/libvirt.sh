#!/usr/bin/env bash
# Manage VM nodes which have a specific set of hardware attributes.

VM_MEMORY=${VM_MEMORY:-4096}
VM_DISK=${VM_DISK:-10}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

function main {
  case "$1" in
    "create") create_docker;;
    "start") start;;
    "reboot") reboot;;
    "shutdown") shutdown;;
    "poweroff") poweroff;;
    "destroy") destroy;;
    *)
      usage
      exit 2
      ;;
  esac
}

function usage {
  echo "USAGE: ${0##*/} <command>"
  echo "Commands:"
  echo -e "\tcreate\t\tcreate QEMU/KVM nodes on the docker0 bridge"
  echo -e "\tstart\t\tstart the QEMU/KVM nodes"
  echo -e "\treboot\t\treboot the QEMU/KVM nodes"
  echo -e "\tshutdown\tshutdown the QEMU/KVM nodes"
  echo -e "\tpoweroff\tpoweroff the QEMU/KVM nodes"
  echo -e "\tdestroy\t\tdestroy the QEMU/KVM nodes"
}

COMMON_VIRT_OPTS="--memory=${VM_MEMORY} --vcpus=4 --disk pool=default,size=${VM_DISK},bus=virtio --os-type=linux --os-variant=generic --noautoconsole --events on_poweroff=preserve"
LONGHORN_VIRT_OPTS="--memory=${VM_MEMORY} --vcpus=4 --disk pool=default,size=${VM_DISK},bus=virtio --disk pool=default,size=${VM_DISK},bus=virtio --os-type=linux --os-variant=generic --noautoconsole --events on_poweroff=preserve"

NODE1_NAME=k8s-node-1
NODE1_MAC=52:54:00:00:00:a1

NODE2_NAME=k8s-node-2
NODE2_MAC=52:54:00:00:00:a2

NODE3_NAME=k8s-node-3
NODE3_MAC=52:54:00:00:00:a3

NODE4_NAME=k8s-node-4_lh
NODE4_MAC=52:54:00:00:00:a4

function create_docker {
  virt-install --name $NODE1_NAME --network=type=direct,source=enp9s0,source_mode=bridge,mac=$NODE1_MAC $COMMON_VIRT_OPTS --boot=network,hd
  virt-install --name $NODE2_NAME --network=type=direct,source=enp9s0,source_mode=bridge,mac=$NODE2_MAC $COMMON_VIRT_OPTS --boot=network,hd
  virt-install --name $NODE3_NAME --network=type=direct,source=enp9s0,source_mode=bridge,mac=$NODE3_MAC $COMMON_VIRT_OPTS --boot=network,hd
  virt-install --name $NODE4_NAME --network=type=direct,source=enp9s0,source_mode=bridge,mac=$NODE4_MAC $LONGHORN_VIRT_OPTS --boot=network,hd
}

nodes=(k8s-node-1 k8s-node-2 k8s-node-3 k8s-node-4_lh )

function start {
  for node in ${nodes[@]}; do
    virsh start $node
  done
}

function reboot {
  for node in ${nodes[@]}; do
    virsh reboot $node
  done
}

function shutdown {
  for node in ${nodes[@]}; do
    virsh shutdown $node
  done
}

function poweroff {
  for node in ${nodes[@]}; do
    virsh destroy $node
  done
}

function destroy {
  for node in ${nodes[@]}; do
    virsh destroy $node
  done
  for node in ${nodes[@]}; do
    virsh undefine $node
  done
  virsh pool-refresh default
  for node in ${nodes[@]}; do
    virsh vol-delete --pool default $node.qcow2
  done
}

main $@
