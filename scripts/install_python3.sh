#!/bin/bash
set -e
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../runtime
PYTHON_URL="https://www.python.org/ftp/python/3.12.6/Python-3.12.6.tar.xz"
PYTHON_INSTALL_PATH="${RUNTIME_PATH}/python3"

# apt install
function install_python3()
{
    apt install -y python3 python3-venv python3-pip
}

# Installing from Source
function source_install_python3()
{(
    set -e
    mkdir -p ${RUNTIME_PATH}/source_python3 ${RUNTIME_PATH}/build_python3
    wget ${PYTHON_URL} -O ${RUNTIME_PATH}/python3.tar.xz
	tar -xf ${RUNTIME_PATH}/python3.tar.xz -C ${RUNTIME_PATH}/source_python3 --strip-components=1
    cd ${RUNTIME_PATH}/build_python3
    bash ../source_python3/configure --prefix=${PYTHON_INSTALL_PATH} --enable-shared
    make -j8 && make install
	ln -snf ${PYTHON_INSTALL_PATH}/bin ${RUNTIME_PATH}/python3_bin
    ln -snf ${PYTHON_INSTALL_PATH}/lib ${RUNTIME_PATH}/python3_lib
    # export LD_LIBRARY_PATH=${ROOT_PATH}/runtime/python3_lib               # 临时生效, 可以 pyinstaller 打包,但是 vscode 无法寻库进行跳转
    echo ${RUNTIME_PATH}/python3_lib > /etc/ld.so.conf.d/libpython3.conf    # 添加到系统默认库路径
    ldconfig                # 刷新库路径 /etc/ld.so.cache
    
    
)}

source_install_python3
