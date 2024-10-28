#!/bin/bash

function stop_nodejs()
{(
    set -eu
    f_pids=$(ps -ef |grep "npm\|vite" |grep -v grep |awk '{print $2}')
    if [[ -z ${f_pids} ]]; then
        echo "stop_nodejs: No running project"
    fi
    if [[ -n ${f_pids} ]]; then
        for pid in ${f_pids}; do
            kill -9 ${pid}
            echo "Successful shutdown [npm|vite]: ${pid}"
        done
    fi

)}

function stop_backend()
{(
    set -eu
    b_pids=$(ps -ef |grep "python3 ${ROOT_PATH}/backend/manage.py\|${ROOT_PATH}/backend/.venv/bin/python3" |grep -v grep|grep -v ".vscode-remote" |awk '{print $2}')
    if [[ -z ${b_pids} ]]; then
        echo "stop_backend: No running project"
    fi

    if [[ -n ${b_pids} ]]; then
        for pid in ${b_pids}; do
            kill -9 ${pid}
            echo "Successful shutdown [python3] : ${pid}"
        done
    fi
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
