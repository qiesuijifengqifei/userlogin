import requests
import pytest
import os
import allure

BASEURL = os.environ.get("requestsBASEURL")
print(BASEURL)


@allure.feature("访问应用首页")
def test_login():
    url = BASEURL + "/login"

    res = requests.get(url=url)
    # print(res.text)
    allure.attach(res.text, "login Page", allure.attachment_type.TEXT)
    assert res.status_code == 200


@allure.feature("用户登录接口")
class TestAPIlogin:
    headers = {"Content-Type": "application/x-www-form-urlencoded;charset=utf8"}
    url = BASEURL + "/api/login"

    @pytest.mark.xfail  # 添加配置优化输出 xfail_strict = True
    def test_loginfail(self):
        _data = {
            "username": "root",
            "password": "123456"
        }

        res = requests.post(url=self.url, headers=self.headers, data=_data)
        allure.attach(res.text)
        assert res.status_code == 200

    def test_loginpass(self):
        _data = {
            "username": "root",
            "password": "root"
        }

        res = requests.post(url=self.url, headers=self.headers, data=_data)
        allure.attach(res.text)
        assert res.status_code == 200
