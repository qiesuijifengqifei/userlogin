from auth.initdb import UserAuth

def get_user(username):
    res = UserAuth.select().where(UserAuth.username==username)
    return res[0]

def verify_password(username, password):
    db_user = get_user(username)
    if not db_user:
        return False
    if db_user.password != password:
        return False
    return db_user