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
		// workerNodes := 2

		masterNodesPubAddr := make([]pulumi.StringOutput, masterNodes)

		// Create a base UserData with Kubic's cloudinit
		var cloudinit = pulumi.String(`#!/bin/bash
		mount /var
		mount /home
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
		// Create master nodes with desiered specifcation
		i := 0
		for i < masterNodes {
			dropletName := fmt.Sprintf("kubicMasterNode-%v", i)
			droplet, err := digitalocean.NewDroplet(ctx, dropletName, &digitalocean.DropletArgs{
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
			masterNodesPubAddr[i] = droplet.Ipv4Address
			i++
		}
		ctx.Export("Ipv4Address", masterNodesPubAddr[2])
		// // Create worker nodes with desiered specifcation
		// i = 0
		// for i < workerNodes {
		// 	dropletName := fmt.Sprintf("kubicWorkerNode-%v", i)
		// 	droplet, err := digitalocean.NewDroplet(ctx, dropletName, &digitalocean.DropletArgs{
		// 		Image:  kubic.ID(),
		// 		Region: pulumi.String("nyc1"),
		// 		Size:   pulumi.String("s-1vcpu-1gb"),
		// 		SshKeys: pulumi.StringArray{
		// 			pulumi.String("28165998"),
		// 		},
		// 		UserData: cloudinit,
		// 	})
		// 	if err != nil {
		// 		fmt.Printf("Error! %v", err)
		// 		return err
		// 	}

		// 	i++
		// }
		return nil
	})
}
