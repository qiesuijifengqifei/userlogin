#!/bin/bash

function build_project()
{(
    set -eu
    local arg=${1-""}
    local BUILD_PATH="${ROOT_PATH}/build"
    function build_backend()
    {(
        # build python3
        source ${ROOT_PATH}/backend/.venv/bin/activate
        rm -rf ${BUILD_PATH}/{backend,backend_build,manage.spec}
        pyinstaller -F ${ROOT_PATH}/backend/manage.py \
        --add-data="${ROOT_PATH}/backend/userlogin/frontend:userlogin/frontend" \
        --add-data="${ROOT_PATH}/backend/userlogin/templates:userlogin/templates" \
        --distpath="backend" --workpath="backend_build" --specpath="backend_build" --hidden-import manage
        cp -f ${ROOT_PATH}/backend/config.ini ${BUILD_PATH}/backend/
        deactivate
    )}
    function build_frontend()
    {(
        # build frontend
        rm -rf ${BUILD_PATH}/frontend
        npm --prefix ${ROOT_PATH}/frontend/userlogin run build
    )}
    function build_web1()
    {(
        # build web1
        rm -rf ${BUILD_PATH}/web1
        npm --prefix ${ROOT_PATH}/web1/web1 run build
    )}

    mkdir -p ${BUILD_PATH}
    cd ${BUILD_PATH}

    case "${arg}" in
        "backend")
            build_backend
        ;;
        "frontend")
            build_frontend
        ;;
        "web1")
            build_web1
        ;;
        "all"|"")
            # build_web1 &
            build_frontend
            build_backend
            wait
        ;;
        *)
            echo "Please output parameters: [ backend | frontend | all ]"
    esac
)}
