#!/bin/bash
set -euo pipefail

function run_backend()
{(
    source ${ROOT_PATH}/backend/.venv/bin/activate
    python3 ${ROOT_PATH}/backend/manage.py dev &
    deactivate
)}

function run_frontend()
{(
    cd ${ROOT_PATH}/frontend/userlogin
    npm run dev &
    cd -
)}

function run_web1()
{(
    cd ${ROOT_PATH}/web1/web1
    npm run dev &
    cd -
)}

function run_pages()
{(
    source ${ROOT_PATH}/pages/.venv/bin/activate
    mkdocs serve -a 0.0.0.0:8001 -f ${ROOT_PATH}/pages/userlogin/mkdocs.yml &
    deactivate
)}

function run_project()
{(
    local type=${1-""}
    case "${type}" in
        "backend")
            run_backend
        ;;
        "frontend")
            run_frontend
        ;;
        "pages")
            run_pages
        ;;
        "all"|"")
            run_backend
            run_frontend
        ;;
        *)
            echo "Please output parameters: [ backend | frontend | pages | all ]"
        ;;
    esac
    
)}
$1