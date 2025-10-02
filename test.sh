#!/bin/bash
docker run -it --network=piracy_default --rm -p 1190:1190 --device /dev/bus/usb/003/002 rtl_fin