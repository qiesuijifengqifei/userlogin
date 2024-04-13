import sqlite3
from os import path


db_file = path.dirname(__file__) + '/users.db'

def init_db() :
    
    if path.exists(db_file):
        print('Database already exists. Skip creation.')
        
    else:
        # 连接到数据库，如果数据库不存在，则会自动创建
        conn = sqlite3.connect(db_file)

        # 创建一个 cursor 对象
        cursor = conn.cursor()
        

        # 创建表
        create_auth = "CREATE TABLE IF NOT EXISTS UserAuthDB(" \
            "id INTEGER primary key AUTOINCREMENT not null unique," \
            "username varchar(64) not null unique," \
            "password varchar(64) not null" \
            ")"
        # 插入数据
        cursor.execute(create_auth)
        cursor.execute("INSERT INTO UserAuthDB (username, password) VALUES ('root', 'root')")

        create_session = "CREATE TABLE IF NOT EXISTS SessionAuthDB(" \
                        "id INTEGER primary key AUTOINCREMENT not null unique," \
                        "username varchar(64) not null unique," \
                        "token varchar(128) not null unique," \
                        "invalid_date int not null" \
                        ")"

        cursor.execute(create_session)
        
        # 打印查询结果
        # rows = cursor.fetchall()
        # for row in rows:
        #     print(row)

        conn.commit()
        # 关闭连接
        conn.close()
        
        print("init db success.")
    