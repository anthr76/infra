package main

import (
	"github.com/pulumi/pulumi-digitalocean/sdk/v3/go/digitalocean"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

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
		_, err = digitalocean.NewDroplet(ctx, "example", &digitalocean.DropletArgs{
			Image:  kubic.ID(),
			Region: pulumi.String("nyc1"),
			Size:   pulumi.String("s-1vcpu-1gb"),
			SshKeys: pulumi.StringArray{
				pulumi.String("28165998"),
			},
		})
		if err != nil {
			return err
		}
		return nil
	})
}
