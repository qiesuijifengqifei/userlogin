#!/bin/bash
set -euo pipefail

GITHUB_REPOSITORY=${GITHUB_REPOSITORY-"qiesuijifengqifei/userlogin"}

# 配置变量
TAG_NAME="v1.0.0"                         # 版本标签
RELEASE_NAME="Release v1.0.0"             # 发布名称
RELEASE_BODY="Description of the release" # 发布说明
ASSET_PATH="build/backend/manage"         # 需要上传的附件文件路径（如果有）
ASSET_NAME=$(basename "${ASSET_PATH}")
TARGET_COMMITISH=$(git rev-parse HEAD)    # 在此 commit id 上打 tag


function curl()
{(
    command curl -s -L \
    -H "Authorization: Bearer ${USER_GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "$@"
)}

function get_release()
{
    curl "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"
}

# 创建Release
function create_release()
{
    curl -X POST \
        https://api.github.com/repos/${GITHUB_REPOSITORY}/releases \
        -d '{
            "tag_name":"'"${TAG_NAME}"'",
            "target_commitish":"'"${TARGET_COMMITISH}"'",
            "name":"'"${RELEASE_NAME}"'",
            "body":"'"${RELEASE_BODY}"'",
            "draft":false,
            "prerelease":false,
            "generate_release_notes":false
            }'
}

# 更新现有 Release
function update_release()
{
    local release_id=$1
    curl -X PATCH \
        https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/${release_id} \
        -d '{
            "tag_name":"'"${TAG_NAME}"'",
            "target_commitish":"'"${TARGET_COMMITISH}"'",
            "name":"'"${RELEASE_NAME}"'",
            "body":"'"${RELEASE_BODY}"'",
            "draft":false,
            "prerelease":false,
            "generate_release_notes":false
            }'
}


# 获取 release 中的所有资产
function get_assets()
{
    local release_id=$1
    curl "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/${release_id}/assets"
}

# 上传资产的函数
function upload_asset()
{
    local release_id=$1
    curl -X POST \
        -H "Content-Type: application/octet-stream" \
        "https://uploads.github.com/repos/${GITHUB_REPOSITORY}/releases/${release_id}/assets?name=${ASSET_NAME}" \
        --data-binary "@${ASSET_PATH}"
}

function delete_asset()
{
    local asset_id=$1
    curl -X DELETE \
        https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/assets/${asset_id}
}

function do_release()
{(
    # 根据 Tag 查找 Release
    existing_release=$(get_release | jq ".[] | select(.tag_name == \"$TAG_NAME\")")

    if [[ -z "${existing_release}" ]]; then
        echo "Release with tag '${TAG_NAME}' does not exist. Creating new release..."

        release_id=$(create_release | jq .id)
        upload_asset "${release_id}"
    else
        echo "Release with tag '${TAG_NAME}' already exists. Updating existing release..."

        # 获取现有 Release 的 ID
        release_id=$(echo "${existing_release}" | jq .id)
        update_release "${release_id}" | jq -c
        existing_assets=$(get_assets "${release_id}" | jq ".[] | select(.name == \"${ASSET_NAME}\")" )

        if [[ -n "${existing_assets}" ]]; then
            # 更新已有的资产
            echo "Asset ${ASSET_NAME} already exists. deleting old version..."

            asset_id=$(echo "${existing_assets}" | jq .id )
            delete_asset "${asset_id}"
            upload_asset "${release_id}" | jq -c
        else
            # 上传资产
            echo "Asset ${ASSET_NAME} does not exists. Uploading new asset"
            upload_asset "${release_id}" | jq -c
        fi
    fi

)}
