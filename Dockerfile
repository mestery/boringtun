FROM rust:slim AS builder

WORKDIR /src
COPY . .
RUN cargo build --release \
    && strip ./target/release/boringtun

FROM debian:stable-slim

WORKDIR /app
COPY --from=builder /src/target/release/boringtun /app
COPY start_wireguard.sh /app

RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list && \
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable && \
    apt update && \
    apt -y install iproute2 net-tools kmod procps tcpdump iputils-ping wireguard

ENV WG_LOG_LEVEL=info \
    WG_THREADS=4 \
    WG_SUDO=1 \
    WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun \
    INTERFACE_NAME=wg0

#ENTRYPOINT /app/boringtun --foreground $INTERFACE_NAME
#ENTRYPOINT tail -f /dev/null
ENTRYPOINT wg-quick up /etc/wireguard/wg0.conf && tail -f /dev/null
