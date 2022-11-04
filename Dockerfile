FROM alpine:latest

ENV TZ=Asia/Taipei

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        tzdata \
        v2ray \
        wireguard-tools \
        proute2 \
        openresolv \
    && cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime \
    && apk del tzdata

COPY rc.local.docker /etc/rc.local.docker

ENTRYPOINT ["/etc/rc.local.docker"]
