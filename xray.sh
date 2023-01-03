#!/bin/sh
#
# This is a Shell script for xray based alpine with Docker image
# 
# Copyright (C) 2019 - 2020 Teddysun <i@teddysun.com>
#
# Reference URL:
# https://github.com/XTLS/Xray-core

PLATFORM=$1

ARCH="amd64"
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download binary file
XRAY_FILE="xray_linux_${ARCH}"

echo "Downloading binary file: ${XRAY_FILE}"

curl -o /usr/bin/xray https://dl.lamp.sh/files/${XRAY_FILE} 

chmod +x /usr/bin/xray
