
from userlogin import app
from config.config import Config
import uvicorn
import sys
import multiprocessing

fastAPIapp = app.app
if __name__ == "__main__":

    multiprocessing.freeze_support()                        # 该方法时阻止子进程运行其后面的代码
    
    if len(sys.argv) > 1 and sys.argv[1] == 'dev':
        print("***** This is a development environment *****")
        uvicorn.run(app="manage:fastAPIapp", host=Config.app_host, port=Config.app_port, reload=True, log_config=Config.log_config, use_colors=True)
    else:
        print("***** This is a production environment *****")
        uvicorn.run(app="manage:fastAPIapp", host=Config.app_host, port=Config.app_port, reload=False, workers=Config.app_threads, log_config=Config.log_config, use_colors=False)