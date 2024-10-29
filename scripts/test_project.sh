#!/bin/bash


function run_pytest()
{(
    set -eu
    source ${SCRIPTS_PATH}/common/kill_ps.sh
    ${ROOT_PATH}/build/backend/manage &
    sleep 3
    source ${ROOT_PATH}/pytest/.venv/bin/activate
    python3 ${ROOT_PATH}/pytest/manage.py
    kill_ps "${ROOT_PATH}/build/backend/manage"
    deactivate
)}


function test_project()
{(
    set -eu
    local type=${1-""}
    run_pytest

)}