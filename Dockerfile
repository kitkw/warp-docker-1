FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

RUN apt-get update && apt-get install -y \
        ca-certificates \
        curl \
        iproute2 \
        iputils-ping \
        lrzsz \
        net-tools \
        openresolv \
        tzdata \
        vim \
        wireguard-tools

COPY rc.local.docker /etc/rc.local.docker

ENTRYPOINT ["/etc/rc.local.docker"]