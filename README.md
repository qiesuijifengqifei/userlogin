# userlogin
前后端分离用户登录功能

# 环境
    linux                       # ubuntu20.04 及以上版本
    python3         (flask)     # python3.8 及以上版本
    nodejs          (vue3)

# 目录结构
    ├── README.md
    ├── backend             # python3项目
    ├── frontend            # 用户登录页面
    ├── web1                # web1项目
    ├── scripts             # 项目 shell 脚本
    └── env.sh              # 项目运行脚本

# 说明
##### 下载代码

    git clone https://github.com/qiesuijifengqifei/userlogin.git

##### 导入项目脚本
    source env.sh

    # 子命令含义
    
    init_env            # 安装项目调试运行的依赖
    run_all             # 运行项目 backend , frontend , web1
    stop_run            # 停止运行的所有项目
    build_all           # 编译所有项目

##### 编译
build , runtime 为编译生成目录  
将 frontend 项目编译部署到 backend 项目中 ( vue3 项目部署到 flask )  
flask 使用 pyinstaller 打包成一个可执行文件  


# 访问
    debug:
        backend: 8000
        frontend: 8081
        web1: 8082
    
    deployed:
    http://127.0.0.1:8000

    注: 可通过 config.ini 文件设置启动端口
    

