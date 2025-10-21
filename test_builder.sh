#!/bin/bash
docker run -it --name=rtl_fin --network=piracy_default --rm -p 1190:1190 --device /dev/bus/usb/003/ -e FREQUENCY=102.1M osplo/rtl_fin:builder /bin/sh