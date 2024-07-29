
# 安装虚拟环境包
apt install -y python3-venv

# 创建虚拟环境
python3 -m venv .venv

echo ".venv" > .gitignore
# 激活虚拟环境
source .venv/bin/activate
# 停用虚拟环境
# deactivate

# 配置 pip 源
pip3 config list -v

echo "
[global]                                                                    
index-url = http://pypi.tuna.tsinghua.edu.cn/simple/
trusted-host = pypi.tuna.tsinghua.edu.cn
" > .venv/pip.conf

# 创建接口目录
mkdir userlogin && cd userlogin

# 安装包
pip3 install flask
echo "
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'flask'

if __name__ == '__main__':
    app.run(port=5000)
" > app.py
mkdir templates static && echo '<div id="app">flask</div>' > templates/index.html
# 运行 flask
# python3 -m flask run #(此命令修改端口无效)
# python3 app.py 

# 可通过文件导入项目依赖包
pip3 freeze > requirements.txt
# pip3 install -r requirements.txt

# 列出虚拟环境所有项目依赖的文本文件
# pip3 list

# 依赖
# pip3 install flask-cors # 解决跨域


