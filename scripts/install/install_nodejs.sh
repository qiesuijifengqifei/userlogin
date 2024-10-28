#!/bin/bash
set -eu
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../../runtime
NODE_URL="https://nodejs.org/dist/v22.7.0/node-v22.7.0-linux-x64.tar.xz"
NODE_INSTALL_PATH="${RUNTIME_PATH}/node"
DOWNLOAD_LOCALNAME=${RUNTIME_PATH}/downloads/nodejs.tar.xz

mkdir -p ${RUNTIME_PATH}/downloads

function install_nodejs()
{(
	mkdir -p ${NODE_INSTALL_PATH}
	wget ${NODE_URL} -O ${DOWNLOAD_LOCALNAME}
	tar -xf ${DOWNLOAD_LOCALNAME} -C ${NODE_INSTALL_PATH} --strip-components=1
	# ln -snf ${NODE_INSTALL_PATH}/bin ${RUNTIME_PATH}/node_bin
)}

install_nodejs