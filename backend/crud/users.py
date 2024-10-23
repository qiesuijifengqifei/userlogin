from db.initdb import UserAuth


def get_user(username):
    # 返回的是一个对象数组
    res = UserAuth.select().where(UserAuth.username==username)
    # 将查询到的结果转换成 dict 传回,需要遍历才能返回字典,默认是 <class 'peewee.ModelSelect'>, 遍历后 <class 'dict'>
    # res = UserAuth.select().where(UserAuth.username==username).dicts()
    # {'id': 1, 'username': 'root', 'password': 'root', 'created': '2024-10-12_09:50:51'
    
    # 这里 username 唯一,故返回第一条数据, UserAuth的实例
    return res[0]

def get_alluser():
    # 返回的是一个字典列表
    # [
    # {
    #     "id": 1,
    #     "username": "root",
    #     "password": "root",
    #     "created": "2024-10-12_09:50:51"
    # }
    # ]
    res: object = UserAuth.select().dicts()
    res_list = []
    for d in res:
        d.pop("password")
        res_list.append(d)
    return res_list

def verify_password(username, password):
    # 根据 username 查询密码匹配 password
    db_user = get_user(username)
    if not db_user:
        return False
    db_password = db_user.password
    if db_password != password:
        return False
    return db_user