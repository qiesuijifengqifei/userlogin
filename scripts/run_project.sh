#!/bin/bash

function run_backend()
{(
    set -euo pipefail
    source ${ROOT_PATH}/backend/.venv/bin/activate
    python3 ${ROOT_PATH}/backend/manage.py dev &
    deactivate
)}

function run_frontend()
{(
    set -eu
    cd ${ROOT_PATH}/frontend/userlogin
    npm run dev &
    cd -
)}

function run_web1()
{(
    set -euo pipefail
    cd ${ROOT_PATH}/web1/web1
    npm run dev &
    cd -
)}

function run_project()
{(
    set -euo pipefail
    local type=${1-""}
    case "${type}" in
        "backend")
            run_backend
        ;;
        "frontend")
            run_frontend
        ;;
        "all"|"")
            run_backend
            run_frontend
        ;;
        *)
            echo "Please output parameters: [ backend | frontend | all ]"
        ;;
    esac
    
)}