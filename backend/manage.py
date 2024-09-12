from userlogin import app
from config import config
from waitress import serve
import sys

flaskapp = app.app
if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == 'dev':
        print("This is a development environment")
        flaskapp.run(host=config.app_host, port=config.app_port)
    else:
        print("This is a production environment")
        serve(
            flaskapp, 
            host=config.app_host, 
            port=config.app_port,
            threads=config.app_threads,
            )

        
