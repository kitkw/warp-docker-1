#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154


cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
. "${ROOT}/configs.sh"


force_build_image='0'
#########################
while [[ $# -gt 0 ]]; do
    key="$1"
    case ${key} in
        --build|-b)
        force_build_image='1'
        shift # past argument
        ;;
        *)
        UNKNOWN_OPTION='1'
        UNKNOWN_OPTION_VALUE="$key"
                # unknown option
        ;;
    esac
    shift # past argument or value
done
###############################


if ! docker -v; then
    echo "Please install docker first before execute this script!"
    exit 0
fi
if docker ps -a | grep -iE "${container_name}" > /dev/null 2>&1; then
    docker container rm -f "${container_name}" > /dev/null 2>&1
fi
if [[ "${force_build_image}" == '1' ]]; then
    "${ROOT}/build_img.sh"
elif ! docker image ls | grep -iE "$img_name" > /dev/null 2>&1; then
    "${ROOT}/build_img.sh"
fi


docker run --restart=always \
    --name "${container_name}" \
    -itd \
    -p 2080:2080 \
    --privileged \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --cap-add net_admin --cap-add sys_module \
    -v "${ROOT}/v2ray/config.json":/etc/v2ray/config.json \
    -v "${ROOT}/rc.local.docker":/etc/rc.local.docker \
    -v "${ROOT}/wireguard":/etc/wireguard \
    -v /lib/modules:/lib/modules \
    "${img_name}"

