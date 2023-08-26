FROM docker.io/library/alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a

COPY ./serials /serials

ADD https://github.com/pftf/RPi4/releases/download/v1.31/RPi4_UEFI_Firmware_v1.31.zip RPi4_UEFI_Firmware.zip

RUN apk add --update --no-cache \
    unzip \
    && mkdir /rpi4 \
    && mv RPi4_UEFI_Firmware.zip /rpi4/RPi4_UEFI_Firmware.zip \
    && cd /rpi4 \
    && ls \
    && unzip RPi4_UEFI_Firmware.zip \
    && rm RPi4_UEFI_Firmware.zip \
    && mkdir /tftp \
    && ls /serials | while read serial; do mkdir /tftp/$serial && cp -r /rpi4/* /tftp/$serial && cp -r /serials/$serial/* /tftp/$serial/; done
