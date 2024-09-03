#!/bin/bash

test "$BASH_SOURCE" = "" && echo "This script can be sourced only from bash" && return
test "$BASH_SOURCE" = "$0" && echo "Script is being run, should be sourced" && exit 1
# test $RUN_FLAG && echo "The environment has been loaded, do nothing" && return || RUN_FLAG=true

ROOT_PATH=$(dirname $(readlink -f $BASH_SOURCE))
PATH=$PATH:${ROOT_PATH}/runtime/runpath

function run_backend()
{(
    source ${ROOT_PATH}/backend/.venv/bin/activate
    python3 ${ROOT_PATH}/backend/manage.py &
    deactivate
)}

function run_fronted()
{(
    cd ${ROOT_PATH}/frontend/userlogin
    npm run dev &
    cd -
)}

function run_web1()
{(
    cd ${ROOT_PATH}/web1/web1
    npm run dev &
    cd -
)}

function run_all()
{(
    run_backend
    run_fronted
    run_web1
)}

function stop_run()
{(
    f_pids=$(ps -ef |grep "npm\|vite" |grep -v grep |awk '{print $2}')
    b_pids=$(ps -ef |grep "python3 ${ROOT_PATH}/backend/manage.py" |grep -v grep |awk '{print $2}')
    if [[ -z ${f_pids} && -z ${b_pids} ]]; then
        echo "No running project"
    fi
    if [[ -n ${f_pids} ]]; then
        for pid in ${f_pids}; do
            kill -9 ${pid}
            echo "Successful shutdown [npm|vite]: ${pid}"
        done
    fi
    if [[ -n ${b_pids} ]]; then
        for pid in ${b_pids}; do
            kill -9 ${pid}
            echo "Successful shutdown [python3] : ${pid}"
        done
    fi
)}

function init_env()
{(
    set -e
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
    
    # 配置 vue3 frontend 开发环境
    cd ${ROOT_PATH}/frontend/userlogin
    npm install
    # 配置 vue3 web1 开发环境
    cd ${ROOT_PATH}/web1/web1
    npm install
    set +e
)}

echo "Environment loading successful"
