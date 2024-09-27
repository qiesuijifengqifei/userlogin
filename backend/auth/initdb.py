from peewee import *
from os import path
from config.config import Config
import datetime

# 使用 ORM 创建 sqlite 数据库
db_file = Config.data_path + "users.db"
db = SqliteDatabase(db_file)


class UserAuth(Model):
    id: int = IntegerField(unique=True, primary_key=True)
    username: str = CharField(unique=True, max_length=16)
    password: str = CharField(max_length=16)
    created: str = DateTimeField(
        default=datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
    )

    class Meta:
        table_name = "UserAuthDB"
        database = db


# class SessionAuth(Model):
#     id: int = IntegerField(unique=True, primary_key=True)
#     username: str = CharField(unique=True, max_length=16)
#     token: str = CharField()
#     invalid_date: int = IntegerField()
#     created: str = DateTimeField(
#         default=datetime.datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
#     )

#     class Meta:
#         table_name = "SessionAuthDB"
#         database = db


def init_db():
    # 连接到数据库，如果数据库不存在，则会自动创建
    if path.exists(db_file):
        print("Database already exists. Skip creation.")

    else:
        print("This is the first time to launch the app.")
        db.connect()
        db.create_tables([UserAuth])
        UserAuth.create(username="root", password="root")
        # root = UserAuth(username="root", password="root")
        # root.save()
        db.close()
        print("init database success.")


