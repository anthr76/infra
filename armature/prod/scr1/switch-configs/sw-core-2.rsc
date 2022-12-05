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
/system identity set name="sw-core-2.sc1.rabbito.tech"


#######################################
# VLAN Overview
#######################################

# 8  = K8s
# 10 = SERVER
# 99 = BASE (MGMT) VLAN
# 806 = 806_END
# 810 = 810_END
# 808 = 808_END
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

# Everything is a trunk port


# egress behavior, handled automatically


#######################################
#
# -- Trunk Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Purple Trunk. Leave pvid set to default of 1
add bridge=bridge interface=sfp-sfpplus1
add bridge=bridge interface=sfp-sfpplus2
add bridge=bridge interface=sfp-sfpplus3
add bridge=bridge interface=sfp-sfpplus4
add bridge=bridge interface=sfp-sfpplus5
add bridge=bridge interface=sfp-sfpplus6
add bridge=bridge interface=sfp-sfpplus7
add bridge=bridge interface=sfp-sfpplus8
add bridge=bridge interface=ether1


# egress behavior
/interface bridge vlan

# Purple Trunk. L2 switching only, Bridge not needed as tagged member (except BASE_VLAN)
add bridge=bridge tagged=sfp-sfpplus2,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=8
add bridge=bridge tagged=sfp-sfpplus2,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=10
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus3,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=806
add bridge=bridge tagged=sfp-sfpplus2,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=808
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus3,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=101
add bridge=bridge tagged=sfp-sfpplus1,sfp-sfpplus3,sfp-sfpplus4,ether1,sfp-sfpplus5 vlan-ids=810
add bridge=bridge tagged=bridge,sfp-sfpplus4,sfp-sfpplus2,ether1,sfp-sfpplus5 vlan-ids=99


#######################################
# IP Addressing & Routing
#######################################

# LAN facing Switch's IP address on a BASE_VLAN
/interface vlan add interface=bridge name=BASE_VLAN vlan-id=99
/ip address add address=10.20.99.10/24 interface=BASE_VLAN

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

# Only allow ingress packets WITH tags on Trunk Ports
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus1]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus2]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus3]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus4]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus5]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus6]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus7]
set bridge=bridge ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp-sfpplus8]
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


#######################################
#
# -- Interface Configuration --
#
#######################################

/interface ethernet


set [ find default-name=ether1 ] comment=sw-1
set [ find default-name=sfp-sfpplus1 ] comment=fw-1
set [ find default-name=sfp-sfpplus2 ] comment=core-1-sfp-sfpplus23
set [ find default-name=sfp-sfpplus3 ] comment=core-1-sfp-sfpplus22
set [ find default-name=sfp-sfpplus4 ] comment=core-1-sfp-sfpplus21

disable sfp-sfpplus6
disable sfp-sfpplus7
disable sfp-sfpplus8


#######################################
# Turn on VLAN mode
#######################################
/interface bridge set bridge vlan-filtering=no
