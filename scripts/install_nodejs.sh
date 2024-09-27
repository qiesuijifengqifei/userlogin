#!/bin/bash
set -e
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../runtime
NODE_URL="https://nodejs.org/dist/v22.7.0/node-v22.7.0-linux-x64.tar.xz"
NODE_INSTALL_PATH="${RUNTIME_PATH}/node"

function install_nodejs()
{(
	set -e
	mkdir -p ${RUNTIME_PATH}/node
	wget ${NODE_URL} -O ${RUNTIME_PATH}/nodejs.tar.xz
	tar -xf ${RUNTIME_PATH}/nodejs.tar.xz -C ${RUNTIME_PATH}/node --strip-components=1
	ln -snf ${NODE_INSTALL_PATH}/bin ${RUNTIME_PATH}/node_bin
)}

install_nodejs