#!/bin/bash

function install_all() 
{(
    set -eu
    if [ -d ${SCRIPTS_PATH}/install ]; then
        for install in ${SCRIPTS_PATH}/install/install_*.sh; do
            if [ -r $install ]; then
                bash $install &
            fi
        done
        wait
        unset install
    fi
)}

function install_one()
{(
    set -eu
    local i_name=$1
    local file_name="${SCRIPTS_PATH}/install/install_${i_name}.sh"
    if [[ -r "${file_name}" ]]; then
        bash ${file_name}
    else
        echo "Wrong parameter: ${i_name}"
    fi
)}


function install_runtime() 
{(
    set -eu
    local i_type=$1
    case "${i_type}" in
        "all"|"")
            install_all
        ;;
        *)
           install_one "${i_type}"
        ;;        
    esac
)}

