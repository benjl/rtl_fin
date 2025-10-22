FROM alpine:3 AS builder

# Dependencies
RUN apk add --no-cache git libusb-dev cmake make build-base
RUN apk add --no-cache musl-dev libshout-dev taglib-dev libxml2-dev check-dev libbsd-dev

# Download and compile rtl_sdr
RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && make

# Download ezstream and patches
RUN cd / && wget https://sources.debian.org/data/main/e/ezstream/1.0.2-2/debian/patches/mp3_incompatibility.patch
RUN wget -O- https://downloads.xiph.org/releases/ezstream/ezstream-1.0.2.tar.gz | tar -xzf - && chown -R root:root /ezstream-1.0.2
COPY ./musl_compat.patch /

# Apply patches
RUN cd /ezstream-1.0.2 && git init && git config user.email "root@root.com" && git config user.name "root" && git add . && git commit -m "Init" && git apply /mp3_incompatibility.patch && git add . && git commit -m "patch1" && git apply /musl_compat.patch && git add . && git commit -m "patch2"

# Compile ezstream
RUN cd /ezstream-1.0.2 && LDFLAGS="-lbsd" ./configure && make


FROM alpine:3 AS runner

RUN apk add --no-cache icecast sox libusb-dev libshout libxml2 taglib libbsd

# Copy over rtl-sdr
RUN mkdir /rtl-sdr
COPY --from=builder /rtl-sdr/build/src/rtl_fm /rtl-sdr/build/src/rtl_sdr /usr/local/bin/
COPY --from=builder /rtl-sdr/build/src/librtlsdr.so.0 /rtl-sdr/build/src/librtlsdr.so.2.0.1 /rtl-sdr/build/src/librtlsdr.so /rtl-sdr/build/src/librtlsdr.a /usr/local/lib/

# Copy over ezstream
COPY --from=builder /ezstream-1.0.2/src/ezstream /usr/bin

# Setup for icecast
RUN mkdir -p /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2 /etc/icecast2
RUN chown -R icecast:icecast /etc/icecast2 /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2

# Copy over cfgs
COPY ./ezstream_cfg_default.xml /
COPY ./icecast_cfg_default.xml /etc/icecast2

COPY ./init.sh /
RUN chmod +x /init.sh

ENV RTLCAST_FREQUENCY=102.1M
ENV RTLCAST_PORT=1190
ENV RTLCAST_SERVERNAME="RTL Radio"
ENV RTLCAST_STREAMNAME="RTL Radio at $RTLCAST_FREQUENCY\Hz"
ENV RTLCAST_DESCRIPTION="Brought to you by rtl-sdr"
ENV RTLCAST_GENRE=Various
ENV RTLCAST_MOUNTPOINT=radio
ENV RTLCAST_LOCATION=Place
ENV RTLCAST_ADMIN_CONTACT=admin@example.com
ENV RTLCAST_ADMIN_USER=admin
ENV RTLCAST_ADMIN_PASSWORD=CHANGEMEPLEASEYOUWILLBEHACKED

ENV RTLCAST_SRC_PASSWORD=fnh429ubfjb9xhfhjh002kpgadgdagadbb
ENV RTLCAST_RELAY_PASSWORD=bf97hf74x9m2HF4246y8fsaf4brr

CMD ["/init.sh"]