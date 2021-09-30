### Pi Matrix

| Mac                 | Serial     | Desired Hostname| Pi     | Known eeprom |
| :------------------ |:----------:| :--------------:| :-----:|:------------:|
|`dc:a6:32:cc:34:a6`  | `56af08e4` | worker-4        | v4 8gb | `000138a1`   |
|`dc:a6:32:46:d6:3c`  | `61895898` | worker-5        | v4 4gb | `000138a1`   |
|`dc:a6:32:39:76:89`  | `1836c205` | worker-7        | v4 4gb | `000138a1`   |
|`dc:a6:32:39:5d:69`  | `8e2bc983` | master-1        | v4 4gb | `000138a1`   |
|`dc:a6:32:03:cf:77`  | `583d6465` | master-2        | v4 4gb | `000138a1`   |
|`dc:a6:32:03:d2:ff`  | `3e79ca27` | master-3        | v4 4gb | `000138a1`   |

[BootOrder Docs](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md)

```
sudo -E rpi-eeprom-config --edit
BOOT_ORDER=0xf241
```
