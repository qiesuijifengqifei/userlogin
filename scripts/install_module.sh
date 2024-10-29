#!/bin/bash

function project_pip3_install()
{(
    # 安装 python3 项目依赖
    set -euo pipefail
    local project=$1

    python3 -m venv ${ROOT_PATH}/${project}/.venv
    echo "
    [global]                                                                    
    index-url = http://pypi.tuna.tsinghua.edu.cn/simple
    trusted-host = pypi.tuna.tsinghua.edu.cn
    " > ${ROOT_PATH}/${project}/.venv/pip.conf
    source ${ROOT_PATH}/${project}/.venv/bin/activate
    pip3 install -r ${ROOT_PATH}/${project}/requirements.txt
    deactivate
)}

function project_npm_install()
{(
    # 安装 vue3 项目依赖
    set -euo pipefail
    local project=$1

    cd ${ROOT_PATH}/${project}
    npm install
    cd -

)}

function install_module()
{(
    set -eu
    local i_type=$1
    case "${i_type}" in
        "backend")
           project_pip3_install "backend"
        ;;
        "pytest")
           project_pip3_install "pytest"
        ;;
        "frontend")
           project_npm_install "frontend/userlogin"
        ;;
        "all"|"")
            project_pip3_install "backend" &
            project_pip3_install "pytest" &
            project_npm_install "frontend/userlogin" &
            wait
        ;;
        *)
           echo "Wrong parameter: ${i_type}"
        ;;
    esac
)}
