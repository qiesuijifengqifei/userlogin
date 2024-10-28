# userlogin
前后端分离用户登录功能

# 环境
    linux           (ubuntu)      # ubuntu20.04 及以上版本
    python3         (fastAPI)     # python3.8 及以上版本
    nodejs          (vue3)

# 目录结构
    ├── README.md
    ├── backend             # python3 项目
    ├── frontend            # vue3 用户登录页面
    ├── web1                # web1 项目
    ├── scripts             # 项目 shell 脚本
    ├── build               # (编译时生成的目录)
    ├── runtime             # (安装的运行环境目录)
    └── porject.sh          # 项目脚本

# 说明
##### 下载代码

    git clone https://github.com/qiesuijifengqifei/userlogin.git

##### 导入项目脚本

    source project.sh

    project help


##### 编译

将 frontend 项目编译部署到 backend 项目中 ( vue3 项目部署到 fastAPI )  
fastAPI 使用 pyinstaller 打包成一个可执行文件  


# 访问
    debug:
        backend: 8000
        frontend: 8081
        web1: 8082
    
    deployed:
    http://127.0.0.1:8000

    注: 可通过 config.ini 文件设置启动端口
    

