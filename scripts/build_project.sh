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
        pyinstaller -F --strip \
        ${ROOT_PATH}/backend/manage.py \
        --name userlogin \
        --hidden-import manage \
        --add-data="${ROOT_PATH}/backend/userlogin/frontend:userlogin/frontend" \
        --add-data="${ROOT_PATH}/backend/userlogin/templates:userlogin/templates" \
        --distpath="backend" --workpath="backend_build" --specpath="backend_build"
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

    # build docker image
    function build_image()
    {(
        GITHUB_REPOSITORY=${GITHUB_REPOSITORY-"qiesuijifengqifei/userlogin"}
        function build_alpine()
        {
            export cmd='
            pip3 install -r /backend/requirements.txt &&
            pyinstaller -F --strip \
            /backend/manage.py \
            --name userlogin \
            --hidden-import manage \
            --add-data="/frontend:userlogin/frontend" \
            --add-data="/backend/userlogin/templates:userlogin/templates"
            '
            docker compose -f builder.yml run --rm builder
        }

        cd ${ROOT_PATH}/docker
        mkdir -p ${BUILD_PATH}/alpine

        build_alpine

        cp -f ${ROOT_PATH}/backend/config.ini ${BUILD_PATH}/alpine/
        docker build -f Dockerfile -t ghcr.io/${GITHUB_REPOSITORY}:latest ${BUILD_PATH}/alpine/
        docker save -o ${BUILD_PATH}/alpine/alpine_userlogin.tar ghcr.io/${GITHUB_REPOSITORY}:latest

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
        "image")
            build_image
        ;;
        "all"|"")
            # build_web1 &
            build_pages &
            build_frontend
            build_backend &
            build_image &
            wait
        ;;
        *)
            echo "Please output parameters: [ backend | frontend | pages | image | all ]"
    esac
)}
$1
