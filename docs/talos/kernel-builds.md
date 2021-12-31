### Building kernel in talos/using pkgs

1. In order to build the talos you need docker. To get docker running under podman:

```
sudo pacman -S docker
set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/podman/podman.sock
```

In order to resolve shortnames in docker/podman you need to set a well known for [moby/buildx](https://github.com/anthr76/dotfiles/blob/main/dot_config/containers/registries.conf.d/001-shortnames.conf)

2. Refer to this [README](https://github.com/talos-systems/pkgs/blob/master/kernel/README.md) and [this](https://github.com/talos-systems/talos/pull/4621/files#diff-b17d107fe7cbed0493c1de3dcd2c9b22bb725eed2129705e3819418c4166b234) to make your customiztions

#TODO
