#!/bin/bash
docker run -it --rm --device /dev/bus/usb/003/002 -v ./output:/output rtl_fin /bin/bash