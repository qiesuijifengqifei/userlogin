from fastapi import Depends, HTTPException, status
from fastapi import APIRouter
from pydantic import BaseModel                                  # api 的模型定义
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm            # 设置登录请求表单格式
import jwt
import time
from crud import users
from jwt.exceptions import InvalidTokenError


router = APIRouter()

JWT_SECRET_KEY = "jiamimiyao"
JWT_ALGORITHM = "HS256"
JWT_TOKEN_EXPIRE = 3600 * 24 * 2
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/api/login')


# 使用 OAuth2PasswordRequestForm 类要求返回此类
# OAuth2PasswordRequestForm 请求头使用 x-www-form-urlencoded
class Response_Token(BaseModel):
    access_token: str
    token_type: str
    

class Response_AllUsers(BaseModel):
    username: str
    created: str | None = None
   
class Response_User(BaseModel):
    username: str
    created: str | None = None
     

# 生成 jwttoken
def generate_jwt_token(username: str):
    token_data = {
        "username": username,
        "expires": int(time.time()) + JWT_TOKEN_EXPIRE
    }
    
    encoded_jwt = jwt.encode(token_data, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)
    return encoded_jwt

# 此处的参数 token 直接从 OAuth2 中提取
# 用作依赖注入,检查用户 token 是否有效
async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        token_data = jwt.decode(token, JWT_SECRET_KEY, algorithms=JWT_ALGORITHM)
        username: str = token_data.get("username", None)
        expires: int = token_data.get("expires", None)
        if username is None or expires is None:
            raise credentials_exception
        
        if expires - int(time.time()) < 0:
            credentials_exception.detail="Token have expired"
            raise credentials_exception
        
        
    except InvalidTokenError:
        raise credentials_exception
    
    user = users.get_user(username=username)

    if user is None:
        raise credentials_exception
    return user


# 登录接口,成功返回 jwt_token
# login_form: OAuth2PasswordRequestForm = Depends() !!! Depends()依赖注入可传方法和类 login_form: OAuth2PasswordRequestForm = Depends(OAuth2PasswordRequestForm) ,当使用类时,可使用简写模式
@router.post("/login")
async def login(login_form: OAuth2PasswordRequestForm = Depends()) -> Response_Token:
    user = users.verify_password(login_form.username, login_form.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = generate_jwt_token(login_form.username)
    
    return Response_Token(access_token=token, token_type="bearer")

@router.get("/allusers")
async def get_allusers(current_user: any = Depends(get_current_user)) -> list:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
        )
    allusers = users.get_alluser()
    if allusers is None:
        raise credentials_exception

    return allusers

@router.get("/userinfo", response_model=Response_User)
async def get_allusers(current_user: any = Depends(get_current_user)):
    return current_user