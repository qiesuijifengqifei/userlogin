#!/bin/bash

THIS_PATH=$(dirname $(readlink -f $BASH_SOURCE))
cd ${THIS_PATH}


apt install -y python3-venv     # 安装虚拟环境包

python3 -m venv .venv           # 创建虚拟环境

echo ".venv" > .gitignore
echo "**/__pycache__" >> .gitignore


source .venv/bin/activate       # 激活虚拟环境
# !!! 使用 vscode 编码时,无法关联包,可点击右下角解释器,切换默认解释器到虚拟环境的 python3 



pip3 config list -v

echo "
[global]                                                                    
index-url = http://pypi.tuna.tsinghua.edu.cn/simple/
trusted-host = pypi.tuna.tsinghua.edu.cn
" > .venv/pip.conf                  # 配置 pip 源


pip3 install mkdocs                 # markdown 生成 html 网页
pip3 install mkdocs-material        # 主题插件

mkdocs new userlogin                # 创建文档项目

# mkdocs build
# mkdocs serve -a 0.0.0.0:8000 -f userlogin/mkdocs.yml     # 启动服务


pip3 freeze > requirements.txt      # 可通过文件导入项目依赖包
# pip3 install -r requirements.txt


# pip3 list                         # 列出虚拟环境所有项目依赖的文本文件
# deactivate                        # 停用虚拟环境

