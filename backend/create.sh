#!/bin/bash

THIS_PATH=$(dirname $(readlink -f $BASH_SOURCE))
cd ${THIS_PATH}


apt install -y python3-venv     # 安装虚拟环境包
python3 -m venv .venv           # 创建虚拟环境

echo ".venv" > .gitignore


source .venv/bin/activate       # 激活虚拟环境
# !!! 使用 vscode 编码时,无法关联包,可点击右下角解释器,切换默认解释器到虚拟环境的 python3 



pip3 config list -v

echo "
[global]                                                                    
index-url = http://pypi.tuna.tsinghua.edu.cn/simple/
trusted-host = pypi.tuna.tsinghua.edu.cn
" > .venv/pip.conf              # 配置 pip 源


mkdir userlogin && cd userlogin


pip3 install fastapi                # 安装包
pip3 install "uvicorn[standard]"

echo '
from fastapi import FastAPI

app = FastAPI()

@app.get(/)
def read_root():
    return {"Hello": "World"}
' > app.py
mkdir templates static && echo '<div id="app">fastAPI</div>' > templates/index.html


pip3 freeze > requirements.txt              # 可通过文件导入项目依赖包


# 运行 fastAPI
# uvicorn app:app --reload                  # (此命令修改端口无效)

# pip3 install peewee                       # Peewee是一种简单而小的ORM
# pip3 install python-multipart
# pip3 install pyjwt                        # 生成 token

# pip3 install -r requirements.txt


# pip3 list                     # 列出虚拟环境所有项目依赖的文本文件

# deactivate                    # 停用虚拟环境
