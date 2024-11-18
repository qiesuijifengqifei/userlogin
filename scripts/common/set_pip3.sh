#!/bin/bash

function set_pip3()
{(
    # 设置 python3 项目的 pip3 源
    local type=${1-""}
    declare -a venv_path=$(find ${ROOT_PATH} -name .venv)
    
    case "${type}" in
    "default" )
        for v in ${venv_path}; do
            echo "clean: ${v}/pip.conf"
            rm -f ${v}/pip.conf
        done
        ;;
    "tsinghua" )
        for v in ${venv_path}; do
            echo "setup: ${v}/pip.conf"
            echo "
            [global]                                                                    
            index-url = http://pypi.tuna.tsinghua.edu.cn/simple
            trusted-host = pypi.tuna.tsinghua.edu.cn
            " > ${v}/pip.conf
        done
        ;;
    esac
)}
$1