from fastapi import FastAPI, Depends

from fastapi.middleware.cors import CORSMiddleware  # 设置响应体允许跨域
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from .routers import users
import os


if os.path.exists(os.path.dirname(__file__) + "/frontend"):
    static_path = os.path.dirname(__file__) + "/frontend"
else:
    static_path = os.path.dirname(__file__) + "/templates"

app = FastAPI()

app.include_router(users.router, prefix="/api", tags=["users"])

app.mount(
    "/static",
    StaticFiles(directory=static_path, html=True),
    name="static",
)

# 设置 api 接口支持跨域
# 浏览器必须首先使用 OPTIONS 方法发起一个预检请求（preflight request），
# 从而获知服务端是否允许该跨域请求。服务器确认允许之后，才发起实际的 HTTP 请求。
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", response_class=FileResponse)
@app.get("/login", response_class=FileResponse)
@app.get("/home", response_class=FileResponse)                      # 解决前端路由页面直接刷新时访问不到
@app.get("/{file_path:path}", response_class=FileResponse)          # 其他路径使用前端路由处理
async def index():
    return static_path + "/index.html"
