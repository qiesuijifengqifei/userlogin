#!/bin/bash
set -eu

function del_deployment() 
{(
    bash ${SCRIPTS_PATH}/api/gh_deployment.sh "del_deployment"
)}

function package()
{(
    local release_path="${BUILD_PATH}/release/userlogin"
    rm -rf ${release_path} && mkdir -p ${release_path}
    cd ${BUILD_PATH}/release

    cp -rf ${BUILD_PATH}/backend/{userlogin,config.ini} ${release_path}
    cp -rf ${BUILD_PATH}/pytest/allure_report/index.html ${release_path}/testreport.html
    tar -czvf linux_amd64_userlogin.tar.gz userlogin
)}

function upload_release()
{(
    test -f ${BUILD_PATH}/release/linux_amd64_userlogin.tar.gz
    bash ${SCRIPTS_PATH}/api/gh_release.sh "upload_release"
)}

$1
