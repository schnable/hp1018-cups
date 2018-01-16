#!/bin/sh

docker kill hp1000-cups
docker rm hp1000-cups
docker run -d \
    --restart always \
    --network host \
    --device /dev/usb/lp0:/dev/usb/lp0 \
    -v /var/log/cups:/var/log/cups \
    --name hp1000-cups \
    hp1000-cups:latest
