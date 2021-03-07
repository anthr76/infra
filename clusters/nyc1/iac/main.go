package main

import (
	"fmt"

	"github.com/pulumi/pulumi-digitalocean/sdk/v3/go/digitalocean"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

// Zypper is not installing packages at the moment. Maybe due to initrd networking bug. Either way the repo is added and user is added so Ansible can take care for now.
func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		kubic, err := digitalocean.NewCustomImage(ctx, "kubic", &digitalocean.CustomImageArgs{
			Url: pulumi.String("https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-Kubic-kubeadm-OpenStack-Cloud.qcow2"),
			Regions: pulumi.StringArray{
				pulumi.String("nyc1"),
			},
		})
		if err != nil {
			return err
		}
		droplet, err := digitalocean.NewDroplet(ctx, "kubicTest", &digitalocean.DropletArgs{
			Image:  kubic.ID(),
			Region: pulumi.String("nyc1"),
			Size:   pulumi.String("s-1vcpu-1gb"),
			SshKeys: pulumi.StringArray{
				pulumi.String("28165998"),
			},
			UserData: pulumi.String(`#!/bin/bash
			mount /var
			mount /home
			useradd -m localanthony
			echo "localanthony ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/localanthony
			mkdir -pm700 /home/localanthony/.ssh
			cp /root/.ssh/authorized_keys /home/localanthony/.ssh/authorized_keys
			chown localanthony:users -R /home/localanthony/.ssh`),
		})

		if err != nil {
			fmt.Printf("Error! %v", err)
			return err
		}
		ctx.Export("Ipv4Address", droplet.Ipv4Address)
		return nil
	})
}
