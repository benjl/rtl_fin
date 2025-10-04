FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y git libusb-1.0.0-dev cmake pkg-config

RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && make TARGET=x86_64-linux-musl

FROM alpine:3 AS runner

RUN apk add --no-cache icecast ezstream sox libusb-dev

RUN mkdir /rtl-sdr
COPY --from=builder /rtl-sdr/build/src/rtl_fm /rtl-sdr/build/src/rtl_sdr /usr/local/bin/
COPY --from=builder /rtl-sdr/build/src/librtlsdr.so.0 /rtl-sdr/build/src/librtlsdr.so.2.0.1 /rtl-sdr/build/src/librtlsdr.so /rtl-sdr/build/src/librtlsdr.a /usr/local/lib/

RUN mkdir -p /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2 /etc/icecast2
RUN chown -R icecast:icecast /etc/icecast2 /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2

COPY ./ezstream_cfg.xml /
COPY ./icecast_cfg.xml /etc/icecast2

COPY ./init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]