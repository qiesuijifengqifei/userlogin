from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel                                  # api 的模型定义
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm            # 设置登录请求表单格式
from fastapi.middleware.cors import CORSMiddleware              # 设置响应体允许跨域
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
import jwt
import time
from auth.runsqlite import verify_password
import os

JWT_SECRET_KEY = "jiamimiyao"
JWT_ALGORITHM = "HS256"
JWT_TOKEN_EXPIRE = 3600 * 24 * 2
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/api/login')


if os.path.exists(os.path.dirname(__file__) + "/frontend"):
    static_path = os.path.dirname(__file__) + "/frontend"
else:
    static_path = os.path.dirname(__file__) + "/templates" 
        
app = FastAPI()
app.mount(
    "/static",
    StaticFiles(directory=static_path, html=True),
    name="static",
)

# 设置 api 接口支持跨域
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 使用 OAuth2PasswordRequestForm 类要求返回此类
# OAuth2PasswordRequestForm 请求体不能使用 json 传数据
class Token(BaseModel):
    access_token: str
    token_type: str
    

def generate_jwt_token(username: str):
    token_data = {
        "username": username,
        "expires": int(time.time()) + JWT_TOKEN_EXPIRE
    }

    encoded_jwt = jwt.encode(token_data, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)
    return encoded_jwt

@app.get("/", response_class=FileResponse)
@app.get("/login", response_class=FileResponse)
async def index():
    return static_path + "/index.html"

@app.post("/api/login")
async def login(login_form: OAuth2PasswordRequestForm = Depends()):
    user = verify_password(login_form.username, login_form.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = generate_jwt_token(login_form.username)
    
    return Token(access_token=token, token_type="bearer")