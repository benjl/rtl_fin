#!/bin/bash
icecast2 -c /etc/icecast2/icecast_cfg.xml
sleep 5 && rtl_fm -f 102.1M -M wbfm -E dc - | sox -t raw -r 32k -b 16 -c 1 -e signed-integer -V1 /dev/stdin -t wavpcm -r 32000 - bandreject 10000 2000 | ices2 /ices_cfg.xml