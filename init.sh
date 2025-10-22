#!/bin/sh
cp /ezstream_cfg_default.xml /ezstream_cfg.xml
cp /etc/icecast2/icecast_cfg_default.xml /etc/icecast2/icecast_cfg.xml

sed -i "s/{FREQUENCY}/$RTLCAST_FREQUENCY/g" /ezstream_cfg.xml
sed -i "s/{PORT}/$RTLCAST_PORT/g" /ezstream_cfg.xml
sed -i "s/{SERVERNAME}/$RTLCAST_SERVERNAME/g" /ezstream_cfg.xml
sed -i "s/{STREAMNAME}/$RTLCAST_STREAMNAME/g" /ezstream_cfg.xml
sed -i "s/{DESCRIPTION}/$RTLCAST_GENRE/g" /ezstream_cfg.xml
sed -i "s/{GENRE}/$RTLCAST_GENRE/g" /ezstream_cfg.xml
sed -i "s/{MOUNTPOINT}/$RTLCAST_MOUNTPOINT/g" /ezstream_cfg.xml
sed -i "s/{SRC_PASSWORD}/$RTLCAST_SRC_PASSWORD/g" /ezstream_cfg.xml
sed -i "s/{RELAY_PASSWORD}/$RTLCAST_RELAY_PASSWORD/g" /ezstream_cfg.xml
sed -i "s/{LOCATION}/$RTLCAST_LOCATION/g" /ezstream_cfg.xml
sed -i "s/{ADMIN_CONTACT}/$RTLCAST_ADMIN_CONTACT/g" /ezstream_cfg.xml
sed -i "s/{ADMIN_USER}/$RTLCAST_ADMIN_USER/g" /ezstream_cfg.xml
sed -i "s/{ADMIN_PASSWORD}/$RTLCAST_ADMIN_PASSWORD/g" /ezstream_cfg.xml

sed -i "s/{FREQUENCY}/$RTLCAST_FREQUENCY/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{PORT}/$RTLCAST_PORT/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{SERVERNAME}/$RTLCAST_SERVERNAME/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{STREAMNAME}/$RTLCAST_STREAMNAME/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{DESCRIPTION}/$RTLCAST_GENRE/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{GENRE}/$RTLCAST_GENRE/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{MOUNTPOINT}/$RTLCAST_MOUNTPOINT/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{SRC_PASSWORD}/$RTLCAST_SRC_PASSWORD/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{RELAY_PASSWORD}/$RTLCAST_RELAY_PASSWORD/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{LOCATION}/$RTLCAST_LOCATION/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{ADMIN_CONTACT}/$RTLCAST_ADMIN_CONTACT/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{ADMIN_USER}/$RTLCAST_ADMIN_USER/g" /etc/icecast2/icecast_cfg.xml
sed -i "s/{ADMIN_PASSWORD}/$RTLCAST_ADMIN_PASSWORD/g" /etc/icecast2/icecast_cfg.xml

icecast -c /etc/icecast2/icecast_cfg.xml &
sleep 5 && rtl_fm -f $RTLCAST_FREQUENCY -M fm -s 170k -A fast -l 0 -E deemp -E dc -g 30 - | sox -t raw -r 170k -b 16 -c 1 -e signed-integer -V1 /dev/stdin -t mp3 -r 32k - | ezstream -c /ezstream_cfg.xml