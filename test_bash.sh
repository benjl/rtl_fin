#!/bin/bash
docker run -it --rm -p 1190:1190 --device /dev/bus/usb/003/002 -v ./output:/output rtl_fin /bin/bash