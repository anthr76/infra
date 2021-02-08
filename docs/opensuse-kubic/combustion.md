# Combustion

[MicroOS RPi Network Monitor](https://rootco.de/2020-12-09-microos-pi-network-monitor/)

[OpenSuse Docs](https://en.opensuse.org/Portal:MicroOS/Combustion)

See [file directory](https://github.com/anthr76/infra/tree/main/docs/combustion-examples) and files for a combustion example. Combustion sits on a micro-sd card in my nodes, and the OS lives on a hard drive.

An example combustion directory tree looks like:

```text
.
└── ignition/
    ├── combustion/
    │   ├── autologin.conf
    │   ├── firstreboot.service
    │   ├── id_rsa.pub
    │   └── script
    └── ignition/
        └── ignition.ign
```

This can be used to package into an ISO.

