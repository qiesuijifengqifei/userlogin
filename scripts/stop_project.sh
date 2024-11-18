#!/bin/bash
set -eu

function stop_nodejs()
{(
    kill_ps "npm"
    kill_ps "vite"
)}

function stop_backend()
{(
    kill_ps "python3 ${ROOT_PATH}/backend/manage.py"
    kill_ps "${ROOT_PATH}/backend/.venv/bin/python3"
)}

function stop_project()
{(
    local type=${1-""}
    source ${SCRIPTS_PATH}/common/kill_ps.sh
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
$1