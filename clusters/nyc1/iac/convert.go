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

func idOutputArrayToIDArrayOutput(as []pulumi.IDOutput) pulumi.IDArrayOutput {
	var outputs []interface{}
	for _, a := range as {
		outputs = append(outputs, a)
	}
	return pulumi.All(outputs...).ApplyIDArray(func(vs []interface{}) []pulumi.ID {
		var results []pulumi.ID
		for _, v := range vs {
			results = append(results, v.(pulumi.ID))
		}
		return results
	})
}

func idOutputArrayToStringOutputArray(as []pulumi.IDOutput) pulumi.StringArrayOutput {
	var outputs []interface{}
	for _, a := range as {
		outputs = append(outputs, a)
	}
	return pulumi.All(outputs...).ApplyStringArray(func(vs []interface{}) []string {
		var results []string
		for _, v := range vs {
			results = append(results, string(v.(pulumi.ID)))
		}
		return results
	})
}
