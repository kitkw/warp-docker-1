#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154


cd "$(dirname "$0")" || exit 1
ROOT="$(pwd)"
. "${ROOT}/configs.sh"


docker build -t "${img_name}" .
