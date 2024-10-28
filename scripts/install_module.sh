#!/bin/bash

function install_module_backend()
{(
    set -euo pipefail
    # 安装 python3 backend 运行依赖
    python3 -m venv ${ROOT_PATH}/backend/.venv
    echo "
    [global]                                                                    
    index-url = http://pypi.tuna.tsinghua.edu.cn/simple
    trusted-host = pypi.tuna.tsinghua.edu.cn
    " > ${ROOT_PATH}/backend/.venv/pip.conf
    source ${ROOT_PATH}/backend/.venv/bin/activate
    pip3 install -r ${ROOT_PATH}/backend/requirements.txt
    deactivate
)}

function install_module_frontend()
{(
    set -euo pipefail

    # 配置 vue3 frontend 开发环境
    cd ${ROOT_PATH}/frontend/userlogin
    npm install

    # 配置 vue3 web1 开发环境
    # cd ${ROOT_PATH}/web1/web1
    # npm install
)}

function install_module()
{(
    set -eu
    local i_type=$1
    case "${i_type}" in
        "backend")
           install_module_backend
        ;;
        "frontend")
           install_module_frontend
        ;;      
        "all"|"")
            install_module_backend &
            install_module_frontend &
            wait
        ;;
        *)
           echo "Wrong parameter: ${i_type}"
        ;;        
    esac
)}
