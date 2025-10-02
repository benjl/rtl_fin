#!/bin/bash
rtl_fm -f 102.1M -M wbfm -E dc - | sox -t raw -r 32k -b 16 -c 1 -e signed-integer -V1 /dev/stdin /output/radioutput.wav bandreject 10000 2000