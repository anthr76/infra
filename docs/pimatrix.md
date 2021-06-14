### Pi Matrix

| Mac                 | Desired Hostname| Pi     | Known eeprom |
| :------------------ |:---------------:| :-----:| :-----------:|
|`dc:a6:32:cc:34:a6`  | worker-4        | v4 8gb | `000138a1`   |
|`dc:a6:32:46:d6:3c`  | worker-5        | v4 4gb | `000138a1`   |
|`dc:a6:32:39:5d:69`  | worker-6        | v4 4gb | `000138a1`   |
|`dc:a6:32:39:76:89`  | worker-7        | v4 4gb | `000138a1`   |
|`dc:a6:32:03:59:4d`  | master-1        | v4 4gb | `000138a1`   |
|`dc:a6:32:03:cf:77`  | master-2        | v4 4gb | `000138a1`   |
|`dc:a6:32:03:d2:ff`  | master-3        | v4 4gb | `000138a1`   |

[BootOrder Docs](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md)

```
sudo -E rpi-eeprom-config --edit
BOOT_ORDER=0xf241
```
