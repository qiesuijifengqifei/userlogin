#!/bin/bash
test "$BASH_SOURCE" = "" && echo "This script can be sourced only from bash" && return
test "$BASH_SOURCE" = "$0" && echo "Script is being run, should be sourced" && exit 1
# test $RUN_FLAG && echo "The environment has been loaded, do nothing" && return || RUN_FLAG=true

export ROOT_PATH=$(dirname $(readlink -f $BASH_SOURCE))
export RUNTIME_PATH=${ROOT_PATH}/runtime
export SCRIPTS_PATH=${ROOT_PATH}/scripts

export PATH=${RUNTIME_PATH}/node/bin:${RUNTIME_PATH}/python3/bin:${RUNTIME_PATH}/allure/bin:$PATH

source ${SCRIPTS_PATH}/project_completion.sh

rvm_bash_nounset=
# set -u # 报错bash: rvm_bash_nounset: unbound variable


function project()
{(
    local action=$1
    local type=$2
    local type_opt=$3

    case "${action}" in
        "run")
            source ${SCRIPTS_PATH}/run_project.sh
            run_project ${type}
        ;;
        "stop")
            source ${SCRIPTS_PATH}/stop_project.sh
            stop_project ${type}
        ;;
        "build")
            source ${SCRIPTS_PATH}/build_project.sh
            build_project ${type}
        ;;        
        "install")
            case "${type}" in
                "runtime")
                    source ${SCRIPTS_PATH}/install_runtime.sh
                    install_runtime "${type_opt}"
                ;;
                "module")
                    source ${SCRIPTS_PATH}/install_module.sh
                    install_module "${type_opt}"
                ;;
                *)
                    echo "The second parameter supports options: [ runtime | module ]"
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
            echo -e "\t   [ install ]"
            echo -e "\t\t [ runtime | module ]"
        ;;
        *)
            echo "The first parameter supports options: [ run | stop | build | install ]"
            exit 0
        ;;
    esac
    
)}

echo "Environment loading successful"
