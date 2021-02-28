package main

import (
    "github.com/pulumi/pulumi-digitalocean/sdk/v3/go/digitalocean"
    "github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        _, err := digitalocean.NewProject(ctx, "iac", &digitalocean.ProjectArgs{
            Description: pulumi.String("A project to represent all digitalocean assets managed with IaC"),
            Environment: pulumi.String("Production"),
	    Purpose:     pulumi.String("Operational/Developer tooling"),
        })
        if err != nil {
            return err
        }
        return nil
    })
}
