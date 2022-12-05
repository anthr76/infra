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
/system identity set name="sw-2.scr1.rabbito.tech"


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
/interface bridge add name=bridge protocol-mode=rtsp vlan-filtering=no


#######################################
#
# -- Access Ports --
#
#######################################

# ingress behavior
/interface bridge port

add bridge=bridge interface=ether2 pvid=10
add bridge=bridge interface=ether3 pvid=10
add bridge=bridge interface=ether4 pvid=10
add bridge=bridge interface=ether5 pvid=10
add bridge=bridge interface=ether6 pvid=10
add bridge=bridge interface=ether7 pvid=10
add bridge=bridge interface=ether8 pvid=10
add bridge=bridge interface=ether9 pvid=10
add bridge=bridge interface=ether10 pvid=10
add bridge=bridge interface=ether11 pvid=10
add bridge=bridge interface=ether12 pvid=10
add bridge=bridge interface=ether13 pvid=10
add bridge=bridge interface=ether14 pvid=10
add bridge=bridge interface=ether15 pvid=10
add bridge=bridge interface=ether16 pvid=10
add bridge=bridge interface=ether17 pvid=10
add bridge=bridge interface=ether18 pvid=10
add bridge=bridge interface=ether19 pvid=10
add bridge=bridge interface=ether20 pvid=101
add bridge=bridge interface=ether21 pvid=100
add bridge=bridge interface=ether22 pvid=8
add bridge=bridge interface=ether23 pvid=10
add bridge=bridge interface=ether24 pvid=99
add bridge=bridge interface=sfp-sfpplus2 pvid=10

# egress behavior, handled automatically


#######################################
#
# -- Trunk Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Purple Trunk. Leave pvid set to default of 1
add bridge=bridge interface=ether1
add bridge=bridge interface=sfp-sfpplus1

# egress behavior
/interface bridge vlan

# Purple Trunk. L2 switching only, Bridge not needed as tagged member (except BASE_VLAN)
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=8]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=10]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=100]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=101]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=806]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=808]
set bridge=bridge tagged=ether1,sfp-sfpplus1 [find vlan-ids=810]
add bridge=bridge tagged=bridge,ether1,sfp-sfpplus1 vlan-ids=99


#######################################
# IP Addressing & Routing
#######################################

# LAN facing Switch's IP address on a BASE_VLAN
/interface vlan add interface=bridge name=BASE_VLAN vlan-id=99
/ip address add address=10.20.99.15/24 interface=BASE_VLAN

# The Router's IP this switch will use
/ip route add distance=1 gateway=10.20.99.1


#######################################
# IP Services
#######################################
# We have a router that will handle this. Nothing to set here.


#######################################
# VLAN Security
#######################################

# Only allow ingress packets without tags on Access Ports
/interface bridge port
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether2]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether3]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether4]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether5]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether6]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether7]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether8]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether9]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether10]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether11]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether12]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether13]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether14]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether15]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether16]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether17]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether18]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether19]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether20]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether21]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether22]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether23]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether24]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=sfp-sfpplus2]

# Only allow ingress packets WITH tags on Trunk Ports
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus1]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether1]


#######################################
# MAC Server settings
#######################################

# Ensure only visibility and availability from BASE_VLAN, the MGMT network
/interface list add name=BASE
/interface list member add interface=BASE_VLAN list=BASE
/ip neighbor discovery-settings set discover-interface-list=BASE
/tool mac-server mac-winbox set allowed-interface-list=BASE
/tool mac-server set allowed-interface-list=BASE


/interface ethernet

set [ find default-name=ether1 ] comment=temp-uplink
set [ find default-name=ether24 ] comment=mgmt-sw
set [ find default-name=sfp-sfpplus1 ] comment=temp-core-downlink

disable ether2
disable ether3
disable ether4
disable ether5
disable ether6
disable ether7
disable ether9
disable ether10
disable ether11
disable ether12
disable ether13
disable ether14
disable ether15
disable ether17
disable ether18
disable ether19
disable ether20
disable ether21
disable ether22
disable ether23
disable sfp-sfpplus2

#######################################
# Turn on VLAN mode
#######################################
/interface bridge set bridge vlan-filtering=no
