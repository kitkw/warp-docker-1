#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154


cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
. "${ROOT}/configs.sh"


if ! docker -v; then
    echo "Please install docker first before execute this script!"
    exit 0
fi
if docker ps -a | grep -iE "${container_name}" > /dev/null 2>&1; then
    docker container rm -f "${container_name}" > /dev/null 2>&1
fi
if ! docker image ls | grep -iE "$img_name" > /dev/null 2>&1; then
    echo "Using ./build_img.sh to build docker image first before execute this script!"
    exit 1
fi

docker run --restart=always \
    --name "${container_name}" \
    -itd \
    -p 30022:22 \
    --privileged \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --cap-add net_admin --cap-add sys_module \
    -v "${ROOT}/rc.local.docker":/etc/rc.local.docker \
    -v "${ROOT}/wireguard":/etc/wireguard \
    -v /lib/modules:/lib/modules \
    "${img_name}"

