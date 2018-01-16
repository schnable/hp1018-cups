#!/bin/sh

/etc/hotplug/usb/hplj1000

udevd --daemon
cupsd -f
