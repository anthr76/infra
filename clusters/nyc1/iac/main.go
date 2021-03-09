package main

import (
	"fmt"

	"github.com/pulumi/pulumi-digitalocean/sdk/v3/go/digitalocean"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {

		// Set number of nodes for cluster
		masterNodes := 3
		workerNodes := 2

		// Create a base UserData with Kubic's cloudinit
		var cloudinit = pulumi.String(`#!/bin/bash
		mount /var
		mount /home
		cp /etc/sysconfig/network/ifcfg-eth0 /etc/sysconfig/network/ifcfg-eth1
		wicked ifup eth1
		useradd -m localanthony
		echo "localanthony ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/localanthony
		mkdir -pm700 /home/localanthony/.ssh
		cp /root/.ssh/authorized_keys /home/localanthony/.ssh/authorized_keys
		chown localanthony:users -R /home/localanthony/.ssh`)

		// Pull latest Kubic Image to use with DigitalOcean in NYC1
		kubic, err := digitalocean.NewCustomImage(ctx, "kubic", &digitalocean.CustomImageArgs{
			Url: pulumi.String("https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-Kubic-kubeadm-OpenStack-Cloud.qcow2"),
			Regions: pulumi.StringArray{
				pulumi.String("nyc1"),
			},
		})
		if err != nil {
			return err
		}
		// Create master nodes with desired specification
		var masterPublicIps []pulumi.StringOutput
		var masterPrivateIps []pulumi.StringOutput
		i := 0
		for i < masterNodes {
			dropletName := fmt.Sprintf("kubicMasterNode-%v", i)
			masterDroplets, err := digitalocean.NewDroplet(ctx, dropletName, &digitalocean.DropletArgs{
				Image:  kubic.ID(),
				Region: pulumi.String("nyc1"),
				Size:   pulumi.String("s-1vcpu-1gb"),
				SshKeys: pulumi.StringArray{
					pulumi.String("28165998"),
				},
				UserData: cloudinit,
			})
			if err != nil {
				fmt.Printf("Error! %v", err)
				return err
			}
			masterPublicIps = append(masterPublicIps, masterDroplets.Ipv4Address)
			masterPrivateIps = append(masterPrivateIps, masterDroplets.Ipv4AddressPrivate)
			i++
		}
		// Create worker nodes with desired specification
		var workerPublicIps []pulumi.StringOutput
		var workerPrivateIps []pulumi.StringOutput
		i = 0
		for i < workerNodes {
			dropletName := fmt.Sprintf("kubicWorkerNode-%v", i)
			workerDroplets, err := digitalocean.NewDroplet(ctx, dropletName, &digitalocean.DropletArgs{
				Image:  kubic.ID(),
				Region: pulumi.String("nyc1"),
				Size:   pulumi.String("s-1vcpu-1gb"),
				SshKeys: pulumi.StringArray{
					pulumi.String("28165998"),
				},
				UserData: cloudinit,
			})
			if err != nil {
				fmt.Printf("Error! %v", err)
				return err
			}
			workerPublicIps = append(workerPublicIps, workerDroplets.Ipv4Address)
			workerPrivateIps = append(workerPrivateIps, workerDroplets.Ipv4AddressPrivate)
			i++
		}
		// Export relevant outputs for later consumption
		ctx.Export("MastersPublicIPV4", stringOutputArrayToStringArrayOutput(masterPublicIps))
		ctx.Export("MastersPrivateIPV4", stringOutputArrayToStringArrayOutput(masterPrivateIps))
		ctx.Export("WorkerPublicIPV4", stringOutputArrayToStringArrayOutput(workerPublicIps))
		ctx.Export("WorkerPrivateIPV4", stringOutputArrayToStringArrayOutput(workerPrivateIps))
		return nil
	})
}
