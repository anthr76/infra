## Config Validation

To validate a config for Ignition there are binaries for a cli tool called `ignition-validate` available [on the releases page](https://github.com/coreos/ignition). There is also an ignition-validate container: `quay.io/coreos/ignition-validate`.

Example:
```
# This example uses podman, but docker can be used too
podman run --pull=always --rm -i quay.io/coreos/ignition-validate:release - < myconfig.ign
```
