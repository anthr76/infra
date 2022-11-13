FROM docker.io/library/alpine:3.16.3@sha256:b95359c2505145f16c6aa384f9cc74eeff78eb36d308ca4fd902eeeb0a0b161b

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
