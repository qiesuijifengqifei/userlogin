#!/bin/bash
set -eu
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../../runtime
ALLURE_URL="https://github.com/allure-framework/allure2/releases/download/2.31.0/allure-2.31.0.tgz"
ALLURE_INSTALL_PATH="${RUNTIME_PATH}/allure"
DOWNLOAD_LOCALNAME=${RUNTIME_PATH}/downloads/allure.tgz

mkdir -p ${RUNTIME_PATH}/downloads

function install_allure()
{(
	mkdir -p ${ALLURE_INSTALL_PATH}
	wget ${ALLURE_URL} -O ${DOWNLOAD_LOCALNAME}
	tar -xf ${DOWNLOAD_LOCALNAME} -C ${ALLURE_INSTALL_PATH} --strip-components=1
	# ln -snf ${ALLURE_INSTALL_PATH}/bin ${RUNTIME_PATH}/allure_bin			# 软连接后执行 allure 会报错
)}

install_allure