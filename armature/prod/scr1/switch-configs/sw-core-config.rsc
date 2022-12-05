###############################################################################
# Topic:        Using RouterOS to VLAN your network
# Example:        Switch with a separate router (RoaS)
# Web:            https://forum.mikrotik.com/viewtopic.php?t=143620
# RouterOS:        6.43.13
# Date:            April 15, 2021
# Notes:        Start with a reset (/system reset-configuration)
# Thanks:        mkx, sindy
###############################################################################

#######################################
# Naming
#######################################

# name the device being configured
/system identity set name="sw-core-1.sc1.rabbito.tech"


#######################################
# VLAN Overview
#######################################

# 8  = K8s
# 10 = SERVER
# 99 = BASE (MGMT) VLAN
# 100 = END_DEVICES
# 101 = IoT


#######################################
# Bridge
#######################################

# create one bridge, set VLAN mode off while we configure
/interface bridge add name=bridge protocol-mode=rstp vlan-filtering=no


#######################################
#
# -- Access Ports --
#
#######################################

# ingress behavior
/interface bridge port

# qsfp
add bridge=bridge interface=qsfpplus1-1 pvid=10
add bridge=bridge interface=qsfpplus1-2 pvid=10
add bridge=bridge interface=qsfpplus1-3 pvid=10
add bridge=bridge interface=qsfpplus1-4 pvid=10
add bridge=bridge interface=qsfpplus2-1 pvid=10
add bridge=bridge interface=qsfpplus2-2 pvid=10
add bridge=bridge interface=qsfpplus2-3 pvid=10
add bridge=bridge interface=qsfpplus2-4 pvid=10

# sfp
add bridge=bridge interface=sfp-sfpplus2 pvid=10
add bridge=bridge interface=sfp-sfpplus4 pvid=8
add bridge=bridge interface=sfp-sfpplus5 pvid=8
add bridge=bridge interface=sfp-sfpplus6 pvid=8
add bridge=bridge interface=sfp-sfpplus7 pvid=10
add bridge=bridge interface=sfp-sfpplus8 pvid=10
add bridge=bridge interface=sfp-sfpplus9 pvid=10
add bridge=bridge interface=sfp-sfpplus10 pvid=10
add bridge=bridge interface=sfp-sfpplus11 pvid=10
add bridge=bridge interface=sfp-sfpplus12 pvid=10
add bridge=bridge interface=sfp-sfpplus13 pvid=10
add bridge=bridge interface=sfp-sfpplus14 pvid=10
add bridge=bridge interface=sfp-sfpplus15 pvid=10
add bridge=bridge interface=sfp-sfpplus16 pvid=10
add bridge=bridge interface=sfp-sfpplus17 pvid=10
add bridge=bridge interface=sfp-sfpplus18 pvid=10
add bridge=bridge interface=sfp-sfpplus19 pvid=10
add bridge=bridge interface=sfp-sfpplus20 pvid=10
add bridge=bridge interface=sfp-sfpplus21 pvid=10
add bridge=bridge interface=sfp-sfpplus22 pvid=10
add bridge=bridge interface=sfp-sfpplus23 pvid=10
add bridge=bridge interface=sfp-sfpplus24 pvid=10
add bridge=bridge interface=ether1 pvid=99


# egress behavior, handled automatically


#######################################
#
# -- Trunk Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Purple Trunk. Leave pvid set to default of 1
add bridge=bridge interface=sfp-sfpplus3
add bridge=bridge interface=sfp-sfpplus2
add bridge=bridge interface=sfp-sfpplus1
add bridge=bridge interface=sfp-sfpplus22
add bridge=bridge interface=sfp-sfpplus23
add bridge=bridge interface=sfp-sfpplus21

# egress behavior
/interface bridge vlan

# Purple Trunk. L2 switching only, Bridge not needed as tagged member (except BASE_VLAN)
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus23,sfp-sfpplus21 vlan-ids=8
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus23,sfp-sfpplus21 vlan-ids=10
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus23,sfp-sfpplus21 vlan-ids=808
add bridge=bridge tagged=sfp-sfpplus22,sfp-sfpplus21 vlan-ids=806
add bridge=bridge tagged=sfp-sfpplus22,sfp-sfpplus21 vlan-ids=810
add bridge=bridge tagged=sfp-sfpplus22,sfp-sfpplus21 vlan-ids=101
add bridge=bridge tagged=bridge,sfp-sfpplus1,sfp-sfpplus23,sfp-sfpplus21 vlan-ids=99


#######################################
# IP Addressing & Routing
#######################################

# LAN facing Switch's IP address on a BASE_VLAN
/interface vlan add interface=bridge name=BASE_VLAN vlan-id=99
/ip address add address=10.20.99.20/24 interface=BASE_VLAN

# The Router's IP this switch will use
/ip route add distance=1 gateway=10.20.99.1
/ip dns set servers=10.20.99.1


#######################################
# IP Services
#######################################
# We have a router that will handle this. Nothing to set here.


#######################################
# VLAN Security
#######################################

# Only allow ingress packets without tags on Access Ports
/interface bridge port
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus1-1]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus1-2]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus1-3]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus1-4]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus2-1]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus2-2]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus2-3]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=qsfpplus2-4]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus4]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus5]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus6]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus7]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus8]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus9]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus10]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus11]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus12]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus13]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus14]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus15]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus16]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus17]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus18]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus19]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus20]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus24]

# Only allow ingress packets WITH tags on Trunk Ports
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus1]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus2]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus3]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus21]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus22]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus23]


#######################################
# MAC Server settings
#######################################

# Ensure only visibility and availability from BASE_VLAN, the MGMT network
/interface list add name=BASE
/interface list member add interface=BASE_VLAN list=BASE
/ip neighbor discovery-settings set discover-interface-list=BASE
/tool mac-server mac-winbox set allowed-interface-list=BASE
/tool mac-server set allowed-interface-list=BASE


#######################################
#
# -- Interface Configuration --
#
#######################################

/interface ethernet


set [ find default-name=ether1 ] comment=mgmt-sw
set [ find default-name=sfp-sfpplus1 ] comment=fw-1
set [ find default-name=sfp-sfpplus2 ] comment=808-office
set [ find default-name=sfp-sfpplus3 ] comment=sw-2
set [ find default-name=sfp-sfpplus4 ] comment=k8s-worker-1
set [ find default-name=sfp-sfpplus5 ] comment=k8s-worker-2
set [ find default-name=sfp-sfpplus6 ] comment=k8s-worker-1
set [ find default-name=sfp-sfpplus24 ] comment=nas-1
set [ find default-name=sfp-sfpplus21 ] comment=core-2-sfp-4
set [ find default-name=sfp-sfpplus22 ] comment=core-2-sfp-4
set [ find default-name=sfp-sfpplus23 ] comment=core-2-sfp-2


disable qsfpplus1-1
disable qsfpplus1-2
disable qsfpplus1-3
disable qsfpplus1-4
disable qsfpplus2-1
disable qsfpplus2-2
disable qsfpplus2-3
disable qsfpplus2-4
disable sfp-sfpplus7
disable sfp-sfpplus8
disable sfp-sfpplus9
disable sfp-sfpplus10
disable sfp-sfpplus11
disable sfp-sfpplus12
disable sfp-sfpplus13
disable sfp-sfpplus14
disable sfp-sfpplus15
disable sfp-sfpplus16
disable sfp-sfpplus17
disable sfp-sfpplus18
disable sfp-sfpplus19
disable sfp-sfpplus20

#######################################
# Turn on VLAN mode
#######################################
/interface bridge set bridge vlan-filtering=no
