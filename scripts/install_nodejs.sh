#!/bin/bash
set -e
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../runtime

function install_nodejs()
{
	mkdir -p ${RUNTIME_PATH}/node
	wget https://nodejs.org/dist/v22.7.0/node-v22.7.0-linux-x64.tar.xz -O ${RUNTIME_PATH}/nodejs.tar.xz
	tar -xf ${RUNTIME_PATH}/nodejs.tar.xz -C ${RUNTIME_PATH}/node --strip-components=1
	ln -snf ${RUNTIME_PATH}/node/bin ${RUNTIME_PATH}/runpath
}

install_nodejs