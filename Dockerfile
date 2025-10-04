FROM ubuntu:24.04 AS stage1

RUN apt-get update && apt-get install -y git libusb-1.0.0-dev cmake pkg-config sox socat libsox-fmt-mp3
RUN apt-get install -y icecast2 ezstream

RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
    make && make install && ldconfig

RUN useradd --system --no-create-home --shell /usr/sbin/nologin --gid icecast icecast
RUN mkdir -p /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2
RUN chown -R icecast:icecast /etc/icecast2 /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2

COPY ./ezstream_cfg.xml /
RUN cd /etc/icecast2 && rm icecast.xml
COPY ./icecast_cfg.xml /etc/icecast2

COPY ./init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]