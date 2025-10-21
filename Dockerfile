FROM alpine:3 AS builder

WORKDIR /

# Dependencies
RUN apk add --no-cache git libusb-dev cmake make build-base
RUN apk add --no-cache musl-dev libshout-dev taglib-dev libxml2-dev check-dev libbsd-dev
RUN apk add --no-cache meson libsndfile-dev 

# Download and compile rtl_sdr
RUN git clone https://gitea.osmocom.org/sdr/rtl-sdr.git
RUN cd rtl-sdr/ && mkdir build && cd build && cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && make

# Download ezstream and patches
RUN wget https://sources.debian.org/data/main/e/ezstream/1.0.2-2/debian/patches/mp3_incompatibility.patch
RUN wget -O- https://downloads.xiph.org/releases/ezstream/ezstream-1.0.2.tar.gz | tar -xzf - && chown -R root:root /ezstream-1.0.2
COPY ./musl_compat.patch /

# Apply patches
RUN cd /ezstream-1.0.2 && git init && git config user.email "root@root.com" && git config user.name "root" && git add . && git commit -m "Init" && git apply /mp3_incompatibility.patch && git add . && git commit -m "patch1" && git apply /musl_compat.patch && git add . && git commit -m "patch2"

# Compile ezstream
RUN cd /ezstream-1.0.2 && LDFLAGS="-lbsd" ./configure && make

# Download and compile libliquid
RUN git clone https://github.com/jgaeddert/liquid-dsp.git && cd /liquid-dsp && mkdir build && cd build && cmake .. && make

# Download and compile redsea
RUN git clone https://github.com/windytan/redsea.git && cd /redsea && meson setup build && cd build && meson compile

FROM alpine:3 AS runner

WORKDIR /

RUN apk add --no-cache icecast sox libusb-dev libshout libxml2 taglib libbsd

# Copy over rtl-sdr
RUN mkdir /rtl-sdr
COPY --from=builder /rtl-sdr/build/src/rtl_fm /rtl-sdr/build/src/rtl_sdr /usr/local/bin/
COPY --from=builder /rtl-sdr/build/src/librtlsdr.so.0 /rtl-sdr/build/src/librtlsdr.so.2.0.1 /rtl-sdr/build/src/librtlsdr.so /rtl-sdr/build/src/librtlsdr.a /usr/local/lib/

# Copy over ezstream
COPY --from=builder /ezstream-1.0.2/src/ezstream /usr/bin

# Copy over redsea and libliquid
COPY --from=builder /redsea /
COPY --from=builder /liquid-dsp /

# Setup for icecast
RUN mkdir -p /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2 /etc/icecast2
RUN chown -R icecast:icecast /etc/icecast2 /var/run/icecast2 /var/log/icecast2 /var/lib/icecast2

# Copy over cfgs
COPY ./ezstream_cfg.xml /
COPY ./icecast_cfg.xml /etc/icecast2

COPY ./init.sh /
RUN chmod +x /init.sh

CMD ["/init.sh"]