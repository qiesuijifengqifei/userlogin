#!/bin/bash
set -e
RUNTIME_PATH=$(dirname $(readlink -f $BASH_SOURCE))/../runtime

function install_python3()
{
    apt install -y python3 python3-venv python3-pip
}

install_python3
