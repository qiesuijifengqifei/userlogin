#!/bin/bash
set -euo pipefail

function del_deployment()
{(
    # GITHUB_TOKEN 默认不可删除 deployment,需要使用用户自己的 
    # 这里在 codespace 里创建 secret 调用 USER_GITHUB_TOKEN
    curl -s ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/deployments | jq -r '.[].id' | while read deployment_id; do
        echo "Deleting deployment ID: ${deployment_id}"
        curl -s -X DELETE -H "Authorization: token ${USER_GITHUB_TOKEN}" \
        ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/deployments/${deployment_id}
    done
    
)}
$1
