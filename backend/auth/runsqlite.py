import sqlite3
from auth.initdb import db_file

# 验证用户名密码是否合法
def CheckParameters(*kwargs):
    for item in range(len(kwargs)):
        # 先验证长度
        if len(kwargs[item]) >= 256 or len(kwargs[item]) == 0:
            return False

        # 先小写,然后去掉两侧空格,去掉所有空格
        local_string = kwargs[item].lower().strip().replace(" ","")

        # 判断是否只包含 大写 小写 数字
        for kw in local_string:
            if kw.isupper() != True and kw.islower() != True and kw.isdigit() != True:
                return False
    return True

def RunSqlite(table,action,field,value,db = db_file):
    connect = sqlite3.connect(db)
    cursor = connect.cursor()

    # 执行插入动作
    if action == "insert":
        insert = f"insert into {table}({field}) values({value});"
        if insert == None or len(insert) == 0:
            return False
        try:
            cursor.execute(insert)
        except Exception:
            return False

    # 执行更新操作
    elif action == "update":
        update = f"update {table} set {value} where {field};"
        if update == None or len(update) == 0:
            return False
        try:
            cursor.execute(update)
        except Exception:
            return False

    # 执行查询操作
    elif action == "select":
        
        # 查询条件是否为空
        if value == "none":
            select = f"select {field} from {table};"
        else:
            select = f"select {field} from {table} where {value};"

        try:
            ref = cursor.execute(select)
            ref_data = ref.fetchall()
            connect.commit()
            connect.close()
            return ref_data
        except Exception:
            return False

    # 执行删除操作
    elif action == "delete":
        delete = f"delete from {table} where {field};"
        if delete == None or len(delete) == 0:
            return False
        try:
            cursor.execute(delete)
        except Exception:
            return False
    try:
        connect.commit()
        connect.close()
        return True
    except Exception:
        return False
