#!/bin/bash
test "$BASH_SOURCE" = "" && echo "This script can be sourced only from bash" && return
test "$BASH_SOURCE" = "$0" && echo "Script is being run, should be sourced" && exit 1
# test $RUN_FLAG && echo "The environment has been loaded, do nothing" && return || RUN_FLAG=true

export ROOT_PATH=$(dirname $(readlink -f $BASH_SOURCE))
export RUNTIME_PATH=${ROOT_PATH}/runtime
export SCRIPTS_PATH=${ROOT_PATH}/scripts
export BUILD_PATH="${ROOT_PATH}/build"
export PATH=${RUNTIME_PATH}/node/bin:${RUNTIME_PATH}/python3/bin:${RUNTIME_PATH}/allure/bin:$PATH

source ${SCRIPTS_PATH}/project_completion.sh

# rvm_bash_nounset=
# set -u # 报错bash: rvm_bash_nounset: unbound variable


function project()
{(
    local action=$1
    local type=$2
    local type_opt=$3
    set -eEu
    function handler_error()
    {
        echo -e "\033[31m Error occurred. Terminating all processes. \033[0m"
        kill 0
    }

    # ERR (Bash 内部错误信号)
    # SIGCHLD (子进程终止信号) (正常终止也会被捕获)
    # SIGTERM (终止信号) (会打印多次信息)
    # SIGINT (中断信号)
    trap handler_error ERR SIGINT

    { case "${action}" in
        "run")
            bash ${SCRIPTS_PATH}/run_project.sh "run_project ${type}"
        ;;
        "stop")
            bash ${SCRIPTS_PATH}/stop_project.sh "stop_project ${type}"
        ;;
        "build")
            bash ${SCRIPTS_PATH}/build_project.sh "build_project ${type}"
        ;;
        "test")
            bash ${SCRIPTS_PATH}/test_project.sh "run_pytest"
        ;;
        "release")
            case "${type}" in
                "del_deployment")
                    bash ${SCRIPTS_PATH}/release_project.sh "del_deployment"
                ;;
                "package")
                    bash ${SCRIPTS_PATH}/release_project.sh "package"
                ;;
                "upload")
                    bash ${SCRIPTS_PATH}/release_project.sh "upload_release"
                ;;
                *)
                    echo "The second parameter supports options: [ del_deployment | package | upload ]"
                    exit 1
                ;;
            esac
        ;;
        "install")
            case "${type}" in
                "runtime")
                    bash ${SCRIPTS_PATH}/install_runtime.sh "install_runtime ${type_opt}"
                ;;
                "module")
                    bash ${SCRIPTS_PATH}/install_module.sh "install_module ${type_opt}"
                ;;
                *)
                    echo "The second parameter supports options: [ runtime | module ]"
                    exit 1
                ;;
            esac
        ;;
        "set_pip3")
            case "${type}" in
                "default")
                    bash ${SCRIPTS_PATH}/common/set_pip3.sh "set_pip3 default"
                ;;
                "tsinghua")
                    bash ${SCRIPTS_PATH}/common/set_pip3.sh "set_pip3 tsinghua"
                ;;
                *)
                    echo "The second parameter supports options: [ tsinghua | default ]"
                    exit 1
                ;;
            esac
        ;;
        "help")
            echo -e "\n project [ run | stop | build | install ] \n"
            echo -e " These are common project commands used in various situations:"
            echo -e "\t   [ run | build ]"
            echo -e "\t\t [ backend | frontend | all ]"
            echo -e "\t   [ stop ]"
            echo -e "\t\t [ backend | nodejs | all ]"
            echo -e "\t   [ test ]"
            echo -e "\t   [ install ]"
            echo -e "\t\t [ runtime | module ]"
        ;;
        *)
            echo "The first parameter supports options: [ run | stop | build | test | install ]"
            exit 1
        ;;
    esac ; } | 
    if [[ "${action}" == "install" ]]; then
        tee >( tr '\n' '\0' | xargs -0 -L 1 echo -e "\033[36m [INFO] \033[36m \033[0m") >/dev/null | cat -
    else 
        tee >(xargs -L 1 echo -e "\033[36m [INFO] \033[36m \033[0m") >/dev/null | cat -
    fi
)}

echo "Environment loading successful"
