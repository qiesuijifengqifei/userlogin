#!/bin/bash
set -eu

function run_pytest()
{(
    source ${SCRIPTS_PATH}/common/kill_ps.sh
    ${ROOT_PATH}/build/backend/userlogin &
    sleep 3
    source ${ROOT_PATH}/pytest/.venv/bin/activate
    python3 ${ROOT_PATH}/pytest/manage.py
    kill_ps "${ROOT_PATH}/build/backend/userlogin"
    deactivate
)}
$1