FROM alpine:3.21.3 as build
ARG DNSMASQ_VERSION=2.90
# Deps sourced from https://git.alpinelinux.org/aports/tree/main/dnsmasq/APKBUILD
RUN apk add build-base coreutils dbus-dev linux-headers nettle-dev
RUN wget https://www.thekelleys.org.uk/dnsmasq/dnsmasq-$DNSMASQ_VERSION.tar.xz -O- | tar -xJ
WORKDIR dnsmasq-$DNSMASQ_VERSION
RUN make PREFIX=/usr DESTDIR=/ install

FROM alpine:3.21.3
# From https://git.alpinelinux.org/aports/tree/main/dnsmasq/dnsmasq.pre-install
RUN addgroup -S dnsmasq && \
    adduser -S -D -H -h /dev/null -s /sbin/nologin -G dnsmasq -g dnsmasq dnsmasq

COPY --from=build /usr/sbin/dnsmasq /usr/sbin/

ENTRYPOINT [ "/usr/sbin/dnsmasq", "-k" ]
