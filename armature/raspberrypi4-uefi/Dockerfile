FROM docker.io/library/alpine:3.16.3@sha256:9cca3c81a88bc396f041e01cefb1e2b32038ef4a4c89bb08ad505c55b58fce0d

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
