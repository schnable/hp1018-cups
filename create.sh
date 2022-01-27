#!/bin/sh

docker kill hp1018-cups
docker rm hp1018-cups
docker run -d \
    --restart always \
    --network host \
    --device /dev/usb/lp0:/dev/usb/lp0 \
    -v /var/log/cups:/var/log/cups \
    --name hp1018-cups \
    hp1018-cups:latest
