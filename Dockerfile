FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c as build
ARG DNSMASQ_VERSION=2.92test6
# Deps sourced from https://git.alpinelinux.org/aports/tree/main/dnsmasq/APKBUILD
RUN apk add build-base coreutils dbus-dev linux-headers nettle-dev
RUN wget https://www.thekelleys.org.uk/dnsmasq/dnsmasq-$DNSMASQ_VERSION.tar.xz -O- | tar -xJ
WORKDIR dnsmasq-$DNSMASQ_VERSION
RUN make PREFIX=/usr DESTDIR=/ install

FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
# From https://git.alpinelinux.org/aports/tree/main/dnsmasq/dnsmasq.pre-install
RUN addgroup -S dnsmasq && \
    adduser -S -D -H -h /dev/null -s /sbin/nologin -G dnsmasq -g dnsmasq dnsmasq

COPY --from=build /usr/sbin/dnsmasq /usr/sbin/

ENTRYPOINT [ "/usr/sbin/dnsmasq", "-k" ]
