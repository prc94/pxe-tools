# syntax=docker/dockerfile:1

FROM debian:bookworm

RUN apt update && apt install -y apt-utils dnsmasq xz-utils

ARG S6_OVERLAY_VERSION=3.1.6.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY dnsmasq.conf /etc/dnsmasq.conf

RUN mkdir /pxe

COPY undionly.kpxe /pxe
COPY boot.ipxe /pxe

VOLUME /pxe

EXPOSE 67/udp 69/udp

ENTRYPOINT ["/init"]

CMD /usr/sbin/dnsmasq --no-daemon
