#!/bin/bash
docker run -it --rm --device /dev/bus/usb/003/002 -p 1190:1190 -v ./output:/output rtl_fin /bin/bash