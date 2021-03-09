package main

import (
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func stringOutputArrayToStringArrayOutput(as []pulumi.StringOutput) pulumi.StringArrayOutput {
	var outputs []interface{}
	for _, a := range as {
		outputs = append(outputs, a)
	}
	return pulumi.All(outputs...).ApplyStringArray(func(vs []interface{}) []string {
		var results []string
		for _, v := range vs {
			results = append(results, v.(string))
		}
		return results
	})
}
