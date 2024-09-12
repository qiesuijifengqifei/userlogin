import json
import random
import string
import time
from flask import Flask, make_response, jsonify, request, Response, render_template
from flask_cors import CORS
from auth.runsqlite import CheckParameters,RunSqlite
from functools import wraps


app = Flask(__name__, template_folder='frontend', static_url_path='/', static_folder='frontend')
# static_url_path 静态文件访问路径
# static_folder flask读取静态文件路径
CORS(app)       # 设置整体跨域问题

# 登录页面
@app.route("/")
def index():
    return render_template('index.html')

# 检查登录状态 token是否过期的装饰器
def login_check(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print("处理登录逻辑部分: {}".format(request.url))

        response_data = {
            "status": "",
            "message": "",
            "data": {
                "user_id": "",
                "username": "",
                "isvalid ": False,
                "token": ""
            }
        }

        # 得到token 验证是否登陆了,且token没有过期
        local_timestamp = int(time.time())
        get_token = request.headers.get("token")
        # 验证传入参数是否合法
        if CheckParameters(get_token) == True:
            select = RunSqlite("SessionAuthDB","select","token,invalid_date",f"token='{get_token}'")
            # 判断是否存在记录,如果存在,在判断时间戳是否合理
            if select != []:
                # 如果当前时间与数据库比对,大于说明过期了需要删除原来的,让用户重新登录
                if local_timestamp >= int(select[0][1]):
                    print("时间戳过期了")
                    # 删除原来的Token
                    delete = RunSqlite("SessionAuthDB","delete",f"token='{get_token}'","none")
                    if delete == True:
                        response_data["status"] = 200
                        response_data["message"] = 'Token 已过期,请重新登录获取'
                        return json.dumps(response_data, ensure_ascii=False)
                    else:
                        response_data["status"] = 500
                        response_data["message"] = '数据库删除异常,请联系开发者'
                        return json.dumps(response_data, ensure_ascii=False)
                else:
                    # 验证Token是否一致
                    if select[0][0] == get_token:
                        print("Token验证正常,继续执行function_ptr指向代码.")
                        # 返回到原函数
                        response_data["data"]["isvalid"] = True
                        return func(*args, **kwargs)
                    else:
                        print("Token验证错误 {}".format(select))
                        return json.dumps("{'token': 'Token 传入错误'}", ensure_ascii=False)

            # 装饰器调用原函数
            # function_ptr = func(*args, **kwargs)
            

        return json.dumps("{'token': 'Token 验证失败'}", ensure_ascii=False)
    return wrapper


# 登录认证模块
@app.route("/api/login",methods=["POST"])
def login():
    if request.method == "POST":
        # 获取参数信息
        if request.is_json:
            username = request.json.get("username")
            password = request.json.get("password")

            # 验证是否合法
            is_true = CheckParameters(username,password)

            if is_true == True:

                # 响应头的完整写法
                response_data = {
                    "status": "",
                    "message": "",
                    "data": {
                        "user_id": "",
                        "username": username,
                        "token": ""
                    }
                }

                # 查询是否存在该用户
                select = RunSqlite("UserAuthDB", "select", "username,password", f"username='{username}'")
                if len(select) != 0:
                    if select[0][0] == username and select[0][1] == password:

                        # 设置 token 有效时间,单位(秒)
                        time_stamp = int(time.time()) + 60*60*100
                        # 查询Session列表是否存在
                        select_session = RunSqlite("SessionAuthDB","select","token",f"username='{username}'")
                        if select_session != []:
                            update = RunSqlite("SessionAuthDB", "update", f"username='{username}'",f"invalid_date='{time_stamp}'")
                            if update == True:
                                response_data["message"] = "token已存在,更新 token 过期时间成功"
                            else:
                                response_data["message"] = "token已存在,更新 token 过期时间失败"
                            response_data["status"] = '200'
                            response_data["data"]["token"] = select_session[0][0]
                            res = make_response(jsonify(response_data))
                            res.headers["Content-Type"] = "text/json; charset=utf-8"
                            return res

                        # Session不存在则需要重新生成
                        else:
                            # 生成并写入token和过期时间戳
                            token = ''.join(random.sample(string.ascii_letters + string.digits, 32))

                            insert = RunSqlite("SessionAuthDB", "insert", "username,token,invalid_date", f"'{username}','{token}',{time_stamp}")
                            if insert == True:
                                response_data["status"] = '200'
                                response_data["message"] = 'token generated'
                                response_data["data"]["token"] = token
                                res = make_response(jsonify(response_data))
                                res.headers["Content-Type"] = "text/json; charset=utf-8"
                                return res
                                
                    else:
                        response_data["status"] = '400'
                        response_data["message"] = '用户名或密码错误'
                        return json.dumps(response_data, ensure_ascii=False)
            else:
                response_data["status"] = '400'
                response_data["message"] = '输入参数不可用'
                return json.dumps(response_data, ensure_ascii=False)

    response_data["status"] = '400'
    response_data["message"] = '未知错误'
    return json.dumps(response_data, ensure_ascii=False)

# 用户登出
@app.route("/api/logout",methods=["POST"])
@login_check
def logout():
    if request.method == "POST":
        response_data = {
            "status": "",
            "message": ""
        }
        get_token = request.headers.get("token")
        # 清除token
        delete = RunSqlite("SessionAuthDB","delete",f"token='{get_token}'","none")
        if delete == True:
            response_data["status"] = 200
            response_data["message"] = 'Token 已清除'
            return json.dumps(response_data, ensure_ascii=False)
        else:
            response_data["status"] = 500
            response_data["message"] = '数据库删除异常,请联系开发者'
            return json.dumps(response_data, ensure_ascii=False)



# 获取参数函数
@app.route("/api/userinfo", methods=["POST"])
@login_check
def GetPage():
    if request.method == "POST":
        if request.is_json:
            get_token = request.headers.get("token")
            select_name = RunSqlite("SessionAuthDB","select","username",f"token='{get_token}'")
            select_invalid_date= RunSqlite("SessionAuthDB","select","invalid_date",f"token='{get_token}'")
            
            # 相应头的完整写法
            response_data = {
                "status": "",
                "message": "",
                "data": {
                    "user_id": "",
                    "username": "",
                    "isvalid": False,
                    "token": ""
                }
            }

            invalid_time = select_invalid_date[0][0] - int(time.time())

            if invalid_time > 1 and select_name[0][0] != "":
                # 更新 token 有效时间,单位(秒)
                if invalid_time < 60*60*48:
                    time_stamp = int(time.time()) + 60*60*100
                    update = RunSqlite("SessionAuthDB", "update", f"username='{select_name}'",f"invalid_date='{time_stamp}'")
                    if update == True:
                        response_data["message"] = "更新 token 过期时间成功"
                    else:
                        response_data["message"] = "更新 token 过期时间失败"
                response_data["data"]["username"] = select_name[0][0]
                response_data["data"]["isvalid"] = True
            else:
                response_data["message"] = "token 验证失败,请重新登录"
                response_data["data"]["isvalid"] = False
            response_data["status"] = 200
            res = make_response(jsonify(response_data))
            res.headers["Content-Type"] = "text/json; charset=utf-8"
            res.status = 200
            return res

    return json.dumps("{'token': '未知错误'}", ensure_ascii=False)

# 用户注册函数
# @app.route("/register", methods=["POST"])
# def Register():
#     if request.method == "POST":
#         obtain_dict = request.form.to_dict()
#         if len(obtain_dict) != 0 and len(obtain_dict) == 2:

#             print("用户名: {} 密码: {}".format(obtain_dict["username"], obtain_dict["password"]))
#             reg_username = obtain_dict["username"]
#             reg_password = obtain_dict["password"]

#             # 验证是否合法
#             if CheckParameters(reg_username, reg_password) == False:
#                 return json.dumps("{'message': '传入用户名密码不合法'}", ensure_ascii=False)

#             # 查询用户是否存在
#             select = RunSqlite("database.db","UserAuthDB","select","id",f"username='{reg_username}'")
#             if select != []:
#                 return json.dumps("{'message': '用户名已被注册'}", ensure_ascii=False)
#             else:
#                 insert = RunSqlite("database.db","UserAuthDB","insert","username,password",f"'{reg_username}','{reg_password}'")
#                 if insert == True:
#                     return json.dumps("{'message': '注册成功'}", ensure_ascii=False)
#                 else:
#                     return json.dumps("{'message': '注册失败'}", ensure_ascii=False)
#         else:
#             return json.dumps("{'message': '传入参数个数不正确'}", ensure_ascii=False)
#     return json.dumps("{'message': '未知错误'}", ensure_ascii=False)


# 密码修改函数
@app.route("/api/changepassword", methods=["POST"])
@login_check
def modify():
    if request.method == "POST":
        if request.is_json:
            mdf_password = request.json.get("mdf_password")
            get_token = request.headers.get("token")

            print("获取token: {} 修改后密码: {}".format(get_token,mdf_password))

            # 验证是否合法
            if CheckParameters(get_token, mdf_password) == False:
                return json.dumps("{'message': '传入密码不合法'}", ensure_ascii=False)

            # 先得到token对应用户名
            select = RunSqlite("SessionAuthDB","select","username",f"token='{get_token}'")
            if select != []:
                # 接着直接修改密码即可
                modify_username = str(select[0][0])
                print("得到的用户名: {}".format(modify_username))
                update = RunSqlite("UserAuthDB","update",f"username='{modify_username}'",f"password='{mdf_password}'")
                if update == True:
                    # 删除原来的token,让用户重新获取
                    delete = RunSqlite("SessionAuthDB","delete",f"username='{modify_username}'","none")
                    print("删除token状态: {}".format(delete))
                    return json.dumps("{'message': '修改成功,请重新登录获取Token'}", ensure_ascii=False)

                else:
                    return json.dumps("{'message': '修改失败'}", ensure_ascii=False)
            else:
                return json.dumps("{'message': '不存在该Token,无法修改密码'}", ensure_ascii=False)
        else:
            return json.dumps("{'message': '传入参数个数不正确'}", ensure_ascii=False)
    return json.dumps("{'message': '未知错误'}", ensure_ascii=False)


