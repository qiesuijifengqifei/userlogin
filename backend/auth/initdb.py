import sqlite3
from os import path

def init_db() :
    db_file = path.dirname(__file__) + '/users.db'
    if path.exists(db_file):
        print('Database already exists. Skip creation.')
        
    else:
        # 连接到数据库，如果数据库不存在，则会自动创建
        conn = sqlite3.connect(db_file)

        # 创建一个 cursor 对象
        cursor = conn.cursor()
        
        # 创建表
        cursor.execute('''CREATE TABLE IF NOT EXISTS users
                        (id INTEGER PRIMARY KEY AUTOINCREMENT,
                        username TEXT UNIQUE NOT NULL,
                        password TEXT NOT NULL,
                        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                        token    TEXT)
                        ;''')
        
        # 插入数据
        cursor.execute("INSERT INTO users (username, password, token) VALUES ('root', 'root', 'root')")
        
        # 查询数据
        cursor.execute('SELECT * FROM users')

        # 打印查询结果
        rows = cursor.fetchall()
        for row in rows:
            print(row)

        conn.commit()
        # 关闭连接
        conn.close()
        
        print("init db success.")
    
init_db()