#!/usr/bin/env bash

ipmi_tool_command="ipmitool -I lanplus -U $IPMI_USER -P $IPMI_PASS"

$ipmi_tool_command -H worker-1-bmc.nwk1.rabbito.tech power off
$ipmi_tool_command -H worker-3-bmc.nwk1.rabbito.tech power off
$ipmi_tool_command -H worker-2-bmc.nwk1.rabbito.tech power off
sleep 1
$ipmi_tool_command -H worker-1-bmc.nwk1.rabbito.tech chassis bootdev pxe options=efiboot
$ipmi_tool_command -H worker-2-bmc.nwk1.rabbito.tech chassis bootdev pxe options=efiboot
$ipmi_tool_command -H worker-3-bmc.nwk1.rabbito.tech chassis bootdev pxe options=efiboot
sleep 1
$ipmi_tool_command -H worker-1-bmc.nwk1.rabbito.tech power on
$ipmi_tool_command -H worker-2-bmc.nwk1.rabbito.tech power on
$ipmi_tool_command -H worker-3-bmc.nwk1.rabbito.tech power on
