#!/bin/bash
docker run -it --name=rtl_fin --network=piracy_default --rm -p 1190:1190 --device /dev/bus/usb/003/002 rtl_fin /bin/sh