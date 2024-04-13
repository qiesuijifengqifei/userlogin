from userlogin import app

from auth import runsqlite


if __name__ == "__main__":
    app = app.runapp()
    # print(runsqlite.runsqlite("UserAuthDB", "select", "'root'", "'root'"))
