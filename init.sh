#!/bin/bash
rtl_fm -f 102.1M -M wbfm -E dc - | sox -t raw -r 32k -b 16 -c 1 -e signed-integer -V1 /dev/stdin -t mp3 - bandreject 10000 2000 | socat -v TCP-LISTEN:1190,reuseaddr,fork SYSTEM:'echo -e "HTTP/1.1 200 OK\r\nContent-Type: audio/mpeg\r\n\r\n"; cat'
