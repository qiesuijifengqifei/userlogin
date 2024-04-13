from flask import Flask, make_response, jsonify, request
from flask_cors import CORS
from auth import runsqlite


app = Flask(__name__)
# 设置整体跨域问题
CORS(app) 


@app.route("/api/login", methods=["POST"])
def login():
    response_data = {
        "status": "",
        "Content-Type": "text/json",
        "messages": "",
    }
    if request.is_json:
        username = request.json.get("username")
        password = request.json.get("password")
        # 这里添加验证用户名和密码的逻辑
        # ...

        sql = runsqlite.runsqlite("UserAuthDB", "select", username, password)

        if sql:
            print(sql)
            response_data['status'] = '200'
            response_data['messages'] = 'login success'
        else:
            print("xxx")
            response_data['status'] = '500'
            response_data['messages'] = 'login failed'
            
        res = make_response(jsonify(response_data))  # 设置响应体
        # res.status = "200"  # 设置状态码
        # res.headers["Access-Control-Allow-Origin"] = "*"  # 设置允许跨域
        # res.headers["Access-Control-Allow-Methods"] = "PUT,GET,POST,DELETE"
        return res


    


def runapp():
    app.run(port=5000, debug=True)
