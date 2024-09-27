from userlogin import app
from config.config import Config
import uvicorn
import sys

fastAPIapp = app.app
if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == 'dev':
        print("This is a development environment")
        uvicorn.run(app="manage:fastAPIapp", host=Config.app_host, port=Config.app_port, reload=True)
    else:
        print("This is a production environment")
        uvicorn.run(app="manage:fastAPIapp", host=Config.app_host, port=Config.app_port, reload=False, workers=Config.app_threads)