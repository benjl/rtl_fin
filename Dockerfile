FROM ubuntu:24.04 AS stage1

RUN apt-get update && apt-get install -y git libusb-1.0.0-dev cmake pkg-config sox socat libsox-fmt-mp3

RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
    make && make install && ldconfig

COPY ./init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]