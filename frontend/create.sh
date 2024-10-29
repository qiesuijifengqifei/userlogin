#!/bin/bash

THIS_PATH=$(dirname $(readlink -f $BASH_SOURCE))
cd ${THIS_PATH}



# npm creat vite@latest
npm creat vite@5.4.0

cd userlogin

npm install             # 安装依赖



# package.json 记录了安装的包版本,并实时更新
npm install axios                               # 网络请求
npm install element-plus --save
npm install pinia                               # 状态管理
npm install pinia-plugin-persistedstate         # 数据持久化
npm install vue-router@4


# npm 安装包默认安装在当前路径下
# npm run dev           # 启动调试
