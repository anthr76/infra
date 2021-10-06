Note:

On Raspberry Pis sidero-controller-manager needs be patched as noted here https://www.sidero.dev/docs/v0.3/guides/rpi4-as-servers/#patch-metal-controller

There's no good way to do this in GitOps yet though the operator may be our saving grace. At the moment the best thing would be to extract the controller-manager's deployment and patch it here though it's drift I'm not willing to take on.. So for the meantime it will be done manually.
