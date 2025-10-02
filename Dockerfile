FROM ubuntu:24.04

RUN apt-get update && apt-get install -y git libusb-1.0.0-dev cmake
RUN apt-get install -y pkg-config

RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && cmake ../ -DINSTALL_UDEV_RULES=ON && \
    make && make install && ldconfig
