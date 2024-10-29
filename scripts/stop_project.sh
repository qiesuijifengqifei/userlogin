#!/bin/bash

function stop_nodejs()
{(
    set -eu
    source ${SCRIPTS_PATH}/common/kill_ps.sh
    # kill_ps "npm\|vite"
    kill_ps "npm"
    kill_ps "vite"

)}

function stop_backend()
{(
    set -eu
    source ${SCRIPTS_PATH}/common/kill_ps.sh
    # kill_ps "python3 ${ROOT_PATH}/backend/manage.py\|${ROOT_PATH}/backend/.venv/bin/python3"
    kill_ps "python3 ${ROOT_PATH}/backend/manage.py"
    kill_ps "${ROOT_PATH}/backend/.venv/bin/python3"
)}

function stop_project()
{(
    set -eu
    local type=${1-""}
    case "${type}" in
        "backend")
            stop_backend
        ;;
        "nodejs")
            stop_nodejs
        ;;
        "all"|"")
            stop_backend
            stop_nodejs
        ;;
        *)
            echo "Please output parameters: [ backend | nodejs | all ]"
        ;;
    esac
)}
