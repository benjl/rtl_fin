#!/bin/sh
cp /ezstream_cfg.xml /ezstream_freq.xml
sed -i "s/{FREQUENCY}/$FREQUENCY/g" /ezstream_freq.xml
icecast -c /etc/icecast2/icecast_cfg.xml &
sleep 5 && rtl_fm -f $FREQUENCY -M wbfm -E dc -g 30 - | sox -t raw -r 32k -b 16 -c 1 -e signed-integer -V1 /dev/stdin -t mp3 - lowpass 4000 | ezstream -c /ezstream_freq.xml