#!/bin/bash
set -eu

function build_project()
{(
    local arg=${1-""}
    function build_backend()
    {(
        # build python3
        source ${ROOT_PATH}/backend/.venv/bin/activate
        rm -rf ${BUILD_PATH}/{backend,backend_build}
        # --hidden-import 解决某些模块或包被动态导入但没有明确在代码中显示导入的问题
        pyinstaller -F ${ROOT_PATH}/backend/manage.py \
        --name userlogin \
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

    function build_pages()
    {(
        # build pages
        source ${ROOT_PATH}/pages/.venv/bin/activate
        rm -rf ${BUILD_PATH}/site
        mkdocs build -f ${ROOT_PATH}/pages/userlogin/mkdocs.yml
        deactivate
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
        "pages")
            build_pages
        ;;
        "all"|"")
            # build_web1 &
            build_pages &
            build_frontend && build_backend &
            
            wait
        ;;
        *)
            echo "Please output parameters: [ backend | frontend | all ]"
    esac
)}
$1
