from flask import Flask, make_response, jsonify, request


app = Flask(__name__)


@app.route("/api/login", methods=["POST"])
def login():
    response_data = {
        "status": "200",
        "Content-Type": "text/json",
        "messages": "login success",
    }

    if request.is_json:
        user = request.json.get("username")
        password = request.json.get("password")
        # 这里可以添加验证用户名和密码的逻辑
        # ...
        return jsonify({"message": "Login successful"}), 200
    return jsonify({"message": "Invalid login details"}), 401

    res = make_response(jsonify(response_data))  # 设置响应体
    res.status = "200"  # 设置状态码
    res.headers["Access-Control-Allow-Origin"] = "*"  # 设置允许跨域
    res.headers["Access-Control-Allow-Methods"] = "PUT,GET,POST,DELETE"
    return res


if __name__ == "__main__":
    app.run(port=5000, debug=True)
